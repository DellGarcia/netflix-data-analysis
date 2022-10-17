DROP TABLE IF EXISTS tb_type CASCADE;
DROP TABLE IF EXISTS tb_director CASCADE;
DROP TABLE IF EXISTS tb_rating CASCADE;
DROP TABLE IF EXISTS tb_genre CASCADE;
DROP TABLE IF EXISTS tb_country CASCADE;
DROP TABLE IF EXISTS tb_content_director CASCADE;
DROP TABLE IF EXISTS tb_content_genre CASCADE;
DROP TABLE IF EXISTS tb_content CASCADE;

CREATE TABLE tb_type (
    id SERIAL PRIMARY KEY,
    description VARCHAR(10) UNIQUE
);


CREATE TABLE tb_director (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE
);

CREATE TABLE tb_rating (
    id SERIAL PRIMARY KEY,
    description VARCHAR(8) UNIQUE
);

CREATE TABLE tb_genre (
    id SERIAL PRIMARY KEY,
    description VARCHAR(255) UNIQUE
);

CREATE TABLE tb_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE
);

CREATE TABLE tb_content (
    id SERIAL PRIMARY KEY,
	show_id VARCHAR(10) UNIQUE,
    type_id INT,
    rating_id INT,
    country_id INT,
    title VARCHAR(255),
    date_added DATE,
    release_year INT,
    duration VARCHAR(50),
    CONSTRAINT fk_type FOREIGN KEY(type_id) REFERENCES tb_type(id),
    CONSTRAINT fk_rating FOREIGN KEY(rating_id) REFERENCES tb_rating(id),
    CONSTRAINT fk_country FOREIGN KEY(country_id) REFERENCES tb_country(id)
);

CREATE TABLE tb_content_director (
    id SERIAL PRIMARY KEY,
    content_id INT,
    director_id INT,
    CONSTRAINT fk_content FOREIGN KEY(content_id) REFERENCES tb_content(id),
    CONSTRAINT fk_director FOREIGN KEY(director_id) REFERENCES tb_director(id)
);

CREATE TABLE tb_content_genre (
    id SERIAL PRIMARY KEY,
    content_id INT,
    genre_id INT,
    CONSTRAINT fk_content FOREIGN KEY(content_id) REFERENCES tb_content(id),
    CONSTRAINT fk_genre FOREIGN KEY(genre_id) REFERENCES tb_genre(id)
);