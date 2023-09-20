PRAGMA foreign_keys = ON;
DROP TABLE if exists question_likes;
DROP TABLE if exists replies;
DROP TABLE if exists question_follows;
DROP TABLE if exists questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

INSERT INTO
  users (id, fname, lname)
VALUES
  (1, 'Jason', 'Jun'),
  (2, 'Rob', 'Lee'),
  (3, 'Allon', 'Nam'),
  (4, 'Gary', 'Jiang'),
  (5, 'Claudia', 'Aziz'),
  (6, 'Jason', 'Zhang'),
  (7, 'Omar', 'Hammad');


CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions (id, title, body, author_id)
VALUES
  (1, 'Will I get a job?', 'I don''t know if I will get a job', 3),
  (2, 'Is it a good program', 'What do you learn?', 4),
  (3, 'Are the instructors good?', 'How are the instructors? I heard they suck. jk.', 6);




CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,
  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (users_id) REFERENCES users(id)
);

INSERT INTO
  question_follows (id, questions_id, users_id)
VALUES
  (1, 1, 1),
  (2, 1, 6),
  (3, 1, 6),
  (4, 2, 2),
  (5, 3, 5),
  (6, 3, 7);




CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  replies (id, question_id, parent_id, user_id, body)
VALUES
  (1, 1, NULL, 1, 'no'),
  (2, 1, 1, 6, 'yes'),
  (3, 1, 2, 6, 'maybe'),
  (4, 2, NULL, 2, 'i''ve heard good things'),
  (5, 3, NULL, 5, 'they''re also app academy graduates'),
  (6, 3, 5, 7, 'they''re pretty smart');




CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  question_likes (id, user_id, question_id)
VALUES
  (1, 1, 3),
  (2, 6, 1),
  (3, 4, 2);






