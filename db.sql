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
