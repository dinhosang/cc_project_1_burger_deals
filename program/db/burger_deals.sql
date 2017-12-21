DROP TABLE IF EXISTS active_deals;
DROP TABLE IF EXISTS deals;
DROP TABLE IF EXISTS burgers;
DROP TABLE IF EXISTS eateries;
DROP TABLE IF EXISTS deal_types;
DROP TABLE IF EXISTS days;
-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;


CREATE TABLE burgers (
  id SERIAL2 PRIMARY KEY,
  type TEXT NOT NULL,
  name TEXT
);

CREATE TABLE eateries (
  id SERIAL2 PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE days (
  id SERIAL2 PRIMARY KEY,
  day VARCHAR(255)
);

CREATE TABLE deal_types (
  id SERIAL2 PRIMARY KEY,
  type VARCHAR(255)
);

CREATE TABLE deals (
  id SERIAL2 PRIMARY KEY,
  type_id INT2 REFERENCES deal_types(id) ON DELETE CASCADE,
  label TEXT,
  value VARCHAR(255),
  day_id INT2 REFERENCES days(id)
);

CREATE TABLE active_deals (
  id SERIAL2 PRIMARY KEY,
  deal_id INT2 REFERENCES deals(id) ON DELETE CASCADE,
  burger_id INT2 REFERENCES burgers(id) ON DELETE CASCADE NOT NULL,
  eatery_id INT2 REFERENCES eateries(id) ON DELETE CASCADE NOT NULL,
  price INT2
);


INSERT INTO days (day) VALUES ('Monday');
INSERT INTO days (day) VALUES ('Tuesday');
INSERT INTO days (day) VALUES ('Wednesday');
INSERT INTO days (day) VALUES ('Thursday');
INSERT INTO days (day) VALUES ('Friday');
INSERT INTO days (day) VALUES ('Saturday');
INSERT INTO days (day) VALUES ('Sunday');


INSERT INTO deal_types (type) VALUES ('cheapest');
INSERT INTO deal_types (type) VALUES ('fraction');
INSERT INTO deal_types (type) VALUES ('monetary');
