CREATE TABLE IF NOT EXISTS FILMS (
    FILM_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    FILM_NAME VARCHAR(40)   NOT NULL,
    DESCRIPTION VARCHAR(200),
    RELEASE_DATE DATE   NOT NULL,
    DURATION INT   NULL,
    RATE INT NULL,
    MPA_ID INT   NULL,
    CONSTRAINT PK_FILMS PRIMARY KEY (FILM_ID)
);

CREATE TABLE IF NOT EXISTS USERS
(
    USER_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    EMAIL VARCHAR(40) NOT NULL,
    LOGIN VARCHAR(40) NOT NULL,
    USER_NAME VARCHAR(40) NULL,
    BIRTHDAY DATE NULL,
    CONSTRAINT PK_USERS PRIMARY KEY (USER_ID),
    CONSTRAINT UC_USERS_EMAIL UNIQUE (EMAIL),
    CONSTRAINT UC_USERS_LOGIN UNIQUE (LOGIN)
);

CREATE TABLE IF NOT EXISTS GENRES
(
    GENRE_ID INT,
    GENRE_NAME VARCHAR(40),
    CONSTRAINT PK_GENRES PRIMARY KEY (GENRE_ID),
    CONSTRAINT UC_GENRES_NAME_ID UNIQUE (GENRE_NAME)
);

CREATE TABLE IF NOT EXISTS FILM_GENRES
(
    FILM_ID INT,
    GENRE_ID INT,
    CONSTRAINT PK_FILMS_GENRES PRIMARY KEY (FILM_ID, GENRE_ID)
);

CREATE TABLE IF NOT EXISTS MPA
(
    MPA_ID INT NOT NULL,
    MPA_NAME VARCHAR(10)   NOT NULL,
    CONSTRAINT PK_MPA PRIMARY KEY (MPA_ID),
    CONSTRAINT UC_MPA_NAME UNIQUE (MPA_NAME)
);

CREATE TABLE IF NOT EXISTS FRIENDS
(
    USER_ID INT,
    FRIEND_ID INT
);

CREATE TABLE IF NOT EXISTS LIKES
(
    FILM_ID INT,
    USER_ID INT
);

CREATE TABLE IF NOT EXISTS DIRECTORS
(
    DIRECTOR_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    DIRECTOR_NAME VARCHAR(100) NOT NULL,
    CONSTRAINT PK_DIRECTORS PRIMARY KEY (DIRECTOR_ID)
);

CREATE TABLE IF NOT EXISTS REVIEWS (
    REVIEW_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    CONTENT VARCHAR NOT NULL,
    IS_POSITIVE BOOLEAN NOT NULL,
    USER_ID INT NOT NULL,
    FILM_ID INT NOT NULL,
    CONSTRAINT PK_REVIEWS PRIMARY KEY (REVIEW_ID),
    CONSTRAINT FK_REVIEWS_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_REVIEWS_FILM_ID FOREIGN KEY (FILM_ID) REFERENCES FILMS(FILM_ID) ON DELETE CASCADE
);

CREATE UNIQUE INDEX USER_FILM_INDEX
    ON REVIEWS (USER_ID, FILM_ID
);

CREATE TABLE IF NOT EXISTS REVIEWS_LIKES (
    REVIEW_ID INT,
    USER_ID INT,
    IS_LIKE BOOLEAN NOT NULL,
    CONSTRAINT REVIEWS_LIKES_FK FOREIGN KEY (REVIEW_ID) REFERENCES REVIEWS(REVIEW_ID) ON DELETE CASCADE,
  	CONSTRAINT REVIEWS_LIKES_FK_1 FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE
);

CREATE UNIQUE INDEX REVIEW_USER_ID_INDEX
    ON REVIEWS_LIKES (REVIEW_ID, USER_ID
);

--Добавление функционала "режиссёры"

CREATE TABLE IF NOT EXISTS FILM_DIRECTORS
(
    FILM_ID     INT NOT NULL,
    DIRECTOR_ID INT NOT NULL,
    CONSTRAINT PK_FILM_DIRECTORS PRIMARY KEY (FILM_ID, DIRECTOR_ID),
    CONSTRAINT FK_FILM_FILM_ID FOREIGN KEY (FILM_ID) REFERENCES FILMS(FILM_ID) ON DELETE CASCADE,
    CONSTRAINT FK_DIRECTORS_DIRECTOR_ID FOREIGN KEY (DIRECTOR_ID) REFERENCES DIRECTORS(DIRECTOR_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS FEED
(
    EVENT_TIMESTAMP BIGINT NOT NULL,
    USER_ID INT NOT NULL,
    EVENT_TYPE VARCHAR,
    OPERATION VARCHAR,
    EVENT_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    ENTITY_ID INT,
    CONSTRAINT PK_FEED PRIMARY KEY (EVENT_ID)
);

CREATE TABLE IF NOT EXISTS REVIEWS (
    REVIEW_ID INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    CONTENT VARCHAR NOT NULL,
    IS_POSITIVE BOOLEAN NOT NULL,
    USER_ID INT NOT NULL,
    FILM_ID INT NOT NULL,
    CONSTRAINT PK_REVIEWS PRIMARY KEY (REVIEW_ID),
    CONSTRAINT FK_REVIEWS_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_REVIEWS_FILM_ID FOREIGN KEY (FILM_ID) REFERENCES FILMS(FILM_ID) ON DELETE CASCADE
);

ALTER TABLE Films
    ADD CONSTRAINT IF NOT EXISTS fk_Films_mpa_id FOREIGN KEY (mpa_id)
        REFERENCES Mpa (mpa_id);

ALTER TABLE FILMS ADD CONSTRAINT IF NOT EXISTS FK_FILMS_MPA_ID FOREIGN KEY(MPA_ID)
    REFERENCES MPA (MPA_ID) ON DELETE CASCADE;

ALTER TABLE FILM_GENRES ADD CONSTRAINT IF NOT EXISTS FK_FILM_GENRES_FILM_ID FOREIGN KEY(FILM_ID)
    REFERENCES FILMS (FILM_ID) ON DELETE CASCADE;

ALTER TABLE FILM_GENRES ADD CONSTRAINT IF NOT EXISTS FK_FILM_GENRES_GENRE_ID FOREIGN KEY(GENRE_ID)
    REFERENCES GENRES (GENRE_ID) ON DELETE CASCADE;

ALTER TABLE FRIENDS ADD CONSTRAINT IF NOT EXISTS FK_FRIENDS_USER_ID FOREIGN KEY(USER_ID)
    REFERENCES USERS (USER_ID) ON DELETE CASCADE;

ALTER TABLE FRIENDS ADD CONSTRAINT IF NOT EXISTS FK_FRIENDS_FRIENDS_ID FOREIGN KEY(FRIEND_ID)
    REFERENCES USERS (USER_ID) ON DELETE CASCADE;

ALTER TABLE LIKES ADD CONSTRAINT IF NOT EXISTS FK_LIKES_FILM_ID FOREIGN KEY(FILM_ID)
    REFERENCES FILMS (FILM_ID) ON DELETE CASCADE;

ALTER TABLE LIKES ADD CONSTRAINT IF NOT EXISTS FK_LIKES_USER_ID FOREIGN KEY(USER_ID)
    REFERENCES USERS (USER_ID) ON DELETE CASCADE;

ALTER TABLE FILM_DIRECTORS ADD CONSTRAINT IF NOT EXISTS FK_FILM_DIRECTORS_FILM_ID FOREIGN KEY (FILM_ID)
    REFERENCES FILMS (FILM_ID) ON DELETE CASCADE;

ALTER TABLE FILM_DIRECTORS ADD CONSTRAINT IF NOT EXISTS FK_FILM_DIRECTORS_DIRECTOR_ID FOREIGN KEY (DIRECTOR_ID)
    REFERENCES DIRECTORS (DIRECTOR_ID) ON DELETE CASCADE;

ALTER TABLE FEED ADD CONSTRAINT IF NOT EXISTS FK_FEED_USER_ID FOREIGN KEY (USER_ID)
    REFERENCES USERS (USER_ID) ON DELETE CASCADE;

ALTER TABLE Likes
    ADD CONSTRAINT IF NOT EXISTS fk_Likes_user_id FOREIGN KEY (user_id)
        REFERENCES Users (user_id);

ALTER TABLE FILMS ALTER COLUMN FILM_ID RESTART WITH 1;
ALTER TABLE USERS ALTER COLUMN USER_ID RESTART WITH 1;
ALTER TABLE DIRECTORS ALTER COLUMN DIRECTOR_ID RESTART WITH 1;
ALTER TABLE FEED ALTER COLUMN EVENT_ID RESTART WITH 1;
ALTER TABLE REVIEWS ALTER COLUMN REVIEW_ID RESTART WITH 1;