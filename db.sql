DROP TABLE IF EXISTS _User CASCADE;
DROP TABLE IF EXISTS _Event CASCADE;
DROP TABLE IF EXISTS Event_Attendance CASCADE;
DROP TABLE IF EXISTS Report CASCADE;
DROP TABLE IF EXISTS Notification CASCADE;
DROP TABLE IF EXISTS Feedback CASCADE;
DROP TABLE IF EXISTS _Location CASCADE;
DROP TABLE IF EXISTS InstitutionCourse CASCADE;
DROP TABLE IF EXISTS Poll CASCADE;
DROP TABLE IF EXISTS Poll_Answer CASCADE;
DROP TABLE IF EXISTS _Comment CASCADE;
DROP TABLE IF EXISTS Photo_Upload CASCADE;
DROP TABLE IF EXISTS upvoted CASCADE;

DROP TYPE IF EXISTS EventCategories;

-- -------------------------------------------- Types --------------------------------------------

CREATE TYPE EventCategories AS ENUM ('Sports', 'Tech', 'Science', 'Art', 'Entrepreneurship', 'Health', 'Environment', 'Other');
CREATE TYPE PollTypes AS ENUM ('OpenAnswer', 'MultipleChoice', 'Checkboxes', 'LinearScale');

-------------------------------------------- Tables --------------------------------------------

CREATE TABLE _User(
    id uid PRIMARY KEY,
    _name text NOT NULL,
    email text NOT NULL CONSTRAINT user_email_uK UNIQUE,
    username text NOT NULL CONSTRAINT user_username_uK UNIQUE,
    photo text,
    _password text NOT NULL,
    phone_number text,
    biography text,
    linkedin text,
    instagram text,
    twitter text,
    youtube text,
    tiktok text,
    is_organization boolean DEFAULT false NOT NULL,
    is_approved boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    creation_date date DEFAULT CURRENT_DATE NOT NULL ,
    id_institutioncourse INTEGER REFERENCES InstitutionCourse(id) 
);

-- É preciso ver como fazer a cena das categorias
CREATE TABLE _Event(
    id uid PRIMARY KEY,
    title text NOT NULL,
    _description text NOT NULL,
    photo text,
    is_online boolean DEFAULT false NOT NULL,
    link text,
    is_hidden boolean DEFAULT false NOT NULL,
    limit_registration_date date,
    event_date date NOT NULL,
    duration number NOT NULL,
    max_capacity number,
    is_approved boolean DEFAULT false NOT NULL,
    type EventCategories,
    CONSTRAINT limit_registration_date CHECK (limit_registration_date IS NULL OR limit_registration_date >= CURRENT_DATE),
    CONSTRAINT event_date CHECK (event_date >= limit_registration_date),
    CONSTRAINT duration CHECK (duration > 0),
    CONSTRAINT max_capacity CHECK (max_capacity > 0),
    id_location INTEGER REFERENCES _Location(id)
);

CREATE TABLE Event_Attendance(
    id_user INTEGER NOT NULL REFERENCES _User(id),
    id_event INTEGER NOT NULL REFERENCES _Event(id),
    is_attended boolean DEFAULT false NOT NULL,
    is_favorite boolean DEFAULT false NOT NULL,
    is_organizer boolean DEFAULT false NOT NULL,
    PRIMARY KEY (id_user, id_event)
);

CREATE TABLE Report(
    id_user INTEGER NOT NULL REFERENCES _User(id),
    id_event INTEGER NOT NULL REFERENCES _Event(id),
    report_text text NOT NULL,
    is_solved boolean DEFAULT false NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    PRIMARY KEY (id_user, id_event)
);

CREATE TABLE Notification(
    id uid PRIMARY KEY,
    notification_content text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    inviter text,
    date_sent date DEFAULT CURRENT_DATE NOT NULL,
    id_user INTEGER NOT NULL REFERENCES _User(id),
    id_event INTEGER REFERENCES _Event(id)
);

CREATE TABLE Feedback(
    id_user INTEGER NOT NULL REFERENCES _User(id),
    id_event INTEGER NOT NULL REFERENCES _Event(id),
    feedback_text text NOT NULL,
    rating number NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE _Location(
    id uid PRIMARY KEY,
    city text DEFAULT "Porto" NOT NULL,
    street text NOT NULL,
    _number integer,
    zip_code text,
    coordinates point
);

CREATE TABLE InstitutionCourse(
    id uid PRIMARY KEY,
    institution text NOT NULL,
    course text
);

CREATE TABLE Poll(
    id uid PRIMARY KEY,
    question text NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    lower_limit number,
    upper_limit number,
    type PollTypes,
    CONSTRAINT upper_limit CHECK (upper_limit > lower_limit),
    id_event INTEGER NOT NULL REFERENCES _Event(id)
);

CREATE TABLE Poll_Answer(
    id uid PRIMARY KEY,
    answer text NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    id_poll INTEGER NOT NULL REFERENCES Poll(id),
    id_user INTEGER NOT NULL REFERENCES _User(id)
);

CREATE TABLE Poll_Option(
    id uid PRIMARY KEY,
    letter text NOT NULL,
    _content text NOT NULL,
    id_poll INTEGER NOT NULL REFERENCES Poll(id)
);

CREATE TABLE _Comment(
    id uid PRIMARY KEY,
    title text NOT NULL,
    _content text NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    id_user INTEGER NOT NULL REFERENCES _User(id),
    id_event INTEGER NOT NULL REFERENCES _Event(id)
);

CREATE TABLE File_Upload(
    id uid PRIMARY KEY,
    title text NOT NULL,
    _path text NOT NULL,
    _description text NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    id_user INTEGER NOT NULL REFERENCES _User(id),
    id_event INTEGER NOT NULL REFERENCES _Event(id)
);

CREATE TABLE Upvoted(
    user_id INTEGER NOT NULL REFERENCES _User(id),
    comment_id INTEGER NOT NULL REFERENCES _Comment(id),
    PRIMARY KEY (user_id, comment_id)
);

CREATE TABLE Photo(
    id uid PRIMARY KEY, 
    path text NOT NULL,
    id_event INTEGER NOT NULL REFERENCES _Event(id)
);

CREATE TABLE Unblock_Appeal(
    id uid PRIMARY KEY,
    title text NOT NULL,
    _description text NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    id_user INTEGER NOT NULL REFERENCES _User(id)
);

-------------------------------------------- Indexes --------------------------------------------

CREATE INDEX IDX10 ON event USING btree (event_date);
CREATE INDEX IDX11 ON event USING btree (type);
CREATE INDEX IDX12 ON upvote USING btree (id_comment, id_user);

-------------------------------------------- FTS Indexes --------------------------------------------

CREATE INDEX IDX21 ON _Event USING GIN (to_tsvector('english', title));
CREATE INDEX IDX22 ON event USING GIN (to_tsvector('portuguese', coalesce(title,'') || ' ' || coalesce(description,''))); 
CLUSTER event USING IDX22;
CREATE INDEX IDX25 ON "user" USING GIN (to_tsvector('portuguese', coalesce(name,'')));

-------------------------------------------- Triggers --------------------------------------------

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

-------------------------------------------- Transactions --------------------------------------------

--------------
--- TRAN01 ---
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO event (title, description, is_online, link, limit_registration_date, 
                  event_date, duration, max_capacity, type)
VALUES ($title, $description, $is_online, $link, $limit_registration_date,
        $event_date, $duration, $max_capacity, $type)
RETURNING id INTO event_id;

INSERT INTO event_attendance (id_user, id_event, is_organizer)
VALUES ($user_id, event_id, TRUE);

COMMIT;

--------------
--- TRAN02 ---
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO feedback (id_user, id_event, feedback_text, rating, date)
VALUES ($user_id, $event_id, $feedback_text, $rating, CURRENT_DATE);

WITH organizer AS (
    SELECT id_user 
    FROM event_attendance 
    WHERE id_event = $event_id AND is_organizer = TRUE
)

INSERT INTO notification (notification_content, id_user, id_event, date_sent)
SELECT 
    'Novo feedback recebido para seu evento', 
    organizer.id_user, 
    $event_id,
    CURRENT_TIMESTAMP
FROM organizer;

COMMIT;

--------------
--- TRAN03 ---
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

DELETE FROM upvote WHERE id_user = $user_id;
DELETE FROM comment WHERE id_user = $user_id;
DELETE FROM poll_answer WHERE id_user = $user_id;
DELETE FROM event_attendance WHERE id_user = $user_id;
DELETE FROM feedback WHERE id_user = $user_id;
DELETE FROM report WHERE id_user = $user_id;
DELETE FROM file_upload WHERE id_user = $user_id;
DELETE FROM notification WHERE id_user = $user_id;
DELETE FROM unblock_appeal WHERE id_user = $user_id;
DELETE FROM "user" WHERE id = $user_id;

COMMIT;
