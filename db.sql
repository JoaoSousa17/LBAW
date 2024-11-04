CREATE TABLE _User(
    id uid PRIMARY KEY,
    _name text,
    email text,
    username text,
    photo text,
    _password text,
    phone_number text,
    biography text,
    linkedin text,
    instagram text,
    twitter text,
    youtube text,
    tiktok text,
    is_organization boolean,
    is_approved boolean,
    is_admin boolean,
    creation_date date,
    id_institutioncourse uid,
    CONSTRAINT fk_institutioncourse FOREIGN KEY (id_institutioncourse) REFERENCES InstitutionCourse(id),
)

-- É preciso ver como fazer a cena das categorias
CREATE TABLE _Event(
    id uid PRIMARY KEY,
    title text,
    _description text,
    photo text,
    is_online boolean,
    link text,
    is_hidden boolean,
    limit_registration_date date,
    event_date date,
    duration number,
    max_capacity number,
    is_approved boolean,
    id_location uid,
    CONSTRAINT fk_location FOREIGN KEY (id_location) REFERENCES Location(id),

)

CREATE TABLE Event_Attendance(
    id uid PRIMARY KEY,
    is_attended boolean,
    is_favorite boolean,
    is_organizer boolean,
    id_user uid,
    id_event uid,
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE Report(
    id uid PRIMARY KEY,
    report_text text,
    is_solved boolean,
    _date date,
    id_user uid,
    id_event uid,
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE Notification(
    id uid PRIMARY KEY,
    notification_content text,
    is_read boolean,
    date_sent date,
    id_user uid,
    id_event uid,
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE Feedback(
    id uid PRIMARY KEY,
    feedback_text text,
    rating number,
    _date date,
    id_user uid,
    id_event uid,
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE Location(
    id uid PRIMARY KEY,
    city text,
    street text,
    _number number,
    zip_code text,
    coordinates point,
    id_event uid,
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE InstitutionCourse(
    id uid PRIMARY KEY,
    institution text,
    course text,
)

CREATE TABLE Poll(
    id uid PRIMARY KEY,
    question text,
    _date date,
    id_event uid,
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE Poll_Answer(
    id uid PRIMARY KEY,
    answer text,
    _date date,
    id_poll uid,
    id_user uid,
    CONSTRAINT fk_poll FOREIGN KEY (id_poll) REFERENCES Poll(id),
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
)

CREATE TABLE Comment(
    id uid PRIMARY KEY,
    title text,
    content text,
    _date date,
    id_user uid,
    id_event uid,
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE Photo_Upload(
    id uid PRIMARY KEY,
    _path text,
    _description text,
    _date date,
    id_user uid,
    id_event uid,
    CONSTRAINT fk_user FOREIGN KEY (id_user) REFERENCES _User(id),
    CONSTRAINT fk_event FOREIGN KEY (id_event) REFERENCES _Event(id),
)

CREATE TABLE upvoted(
    user_id uid,
    comment_id uid,
    PRIMARY KEY (user_id, comment_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES _User(id),
    CONSTRAINT fk_comment FOREIGN KEY (comment_id) REFERENCES Comment(id),
);

CREATE OR REPLACE FUNCTION check_event_dates()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se a data limite de registo é anterior à data do evento
    IF NEW.limit_registration_date >= NEW.event_date THEN
        RAISE EXCEPTION 'A data limite de registo deve ser anterior à data do evento';
    END IF;
    
    -- Verifica se a data do evento é futura
    IF NEW.event_date <= CURRENT_DATE THEN
        RAISE EXCEPTION 'A data do evento deve ser futura';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_event_dates
BEFORE INSERT OR UPDATE ON _Event
FOR EACH ROW
EXECUTE FUNCTION check_event_dates();

CREATE OR REPLACE FUNCTION check_event_registration()
RETURNS TRIGGER AS $$
DECLARE
    current_attendees INTEGER;
BEGIN
    -- Verifica se o utilizador já está registado
    IF EXISTS (
        SELECT 1 FROM Event_Attendance 
        WHERE id_user = NEW.id_user 
        AND id_event = NEW.id_event
    ) THEN
        RAISE EXCEPTION 'Utilizador já está registado neste evento';
    END IF;

    -- Verifica a capacidade do evento
    SELECT COUNT(*) INTO current_attendees
    FROM Event_Attendance
    WHERE id_event = NEW.id_event;

    IF (SELECT max_capacity FROM Event WHERE id = NEW.id_event) <= current_attendees THEN
        RAISE EXCEPTION 'Evento já atingiu a capacidade máxima';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_event_registration
BEFORE INSERT ON Event_Attendance
FOR EACH ROW
EXECUTE FUNCTION check_event_registration();

CREATE OR REPLACE FUNCTION notify_event_approval()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_approved = true AND (OLD.is_approved = false OR OLD.is_approved IS NULL) THEN
        INSERT INTO Notification (notification_content, is_read, date_sent, id_user, id_event)
        SELECT 
            'O seu evento foi aprovado!',
            false,
            CURRENT_DATE,
            ea.id_user,
            NEW.id
        FROM Event_Attendance ea
        WHERE ea.id_event = NEW.id AND ea.is_organizer = true;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_notify_approval
AFTER UPDATE ON _Event
FOR EACH ROW
EXECUTE FUNCTION notify_event_approval();

-- Função que será usada por todas as tabelas
CREATE OR REPLACE FUNCTION set_current_date()
RETURNS TRIGGER AS $$
BEGIN
    NEW._date := CURRENT_DATE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Um único trigger reutilizado em várias tabelas
CREATE TRIGGER auto_set_date
BEFORE INSERT ON Comment
FOR EACH ROW
EXECUTE FUNCTION set_current_date();

CREATE TRIGGER auto_set_date
BEFORE INSERT ON Photo_Upload
FOR EACH ROW
EXECUTE FUNCTION set_current_date();

-- Podemos adicionar facilmente para outras tabelas que também precisem
CREATE TRIGGER auto_set_date
BEFORE INSERT ON Poll
FOR EACH ROW
EXECUTE FUNCTION set_current_date();

CREATE TRIGGER auto_set_date
BEFORE INSERT ON Poll_Answer
FOR EACH ROW
EXECUTE FUNCTION set_current_date();

CREATE TRIGGER auto_set_date
BEFORE INSERT ON Report
FOR EACH ROW
EXECUTE FUNCTION set_current_date();

CREATE TRIGGER auto_set_date
BEFORE INSERT ON Feedback
FOR EACH ROW
EXECUTE FUNCTION set_current_date();

CREATE OR REPLACE FUNCTION check_unique_email()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM _User WHERE email = NEW.email AND id != NEW.id) THEN
        RAISE EXCEPTION 'Este email já está registado';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_unique_email
BEFORE INSERT OR UPDATE ON _User
FOR EACH ROW
EXECUTE FUNCTION check_unique_email();

CREATE OR REPLACE FUNCTION check_rating_value()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        RAISE EXCEPTION 'O rating deve estar entre 1 e 5';
    END IF;

    IF EXISTS (
        SELECT 1 
        FROM Feedback 
        WHERE id_user = NEW.id_user 
        AND id_event = NEW.id_event
        AND id != NEW.id 
    ) THEN
        RAISE EXCEPTION 'Usuário já deu feedback para este evento';
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM Event_Attendance 
        WHERE id_user = NEW.id_user 
        AND id_event = NEW.id_event
        AND is_attended = true
    ) THEN
        RAISE EXCEPTION 'Apenas usuários que participaram do evento podem dar feedback';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_rating
BEFORE INSERT OR UPDATE ON Feedback
FOR EACH ROW
EXECUTE FUNCTION check_rating_value();
