DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date (
    sk_dim_date SERIAL PRIMARY KEY,
    date_added DATE NOT NULL,
    small_date VARCHAR(12) NOT NULL,
    medium_date VARCHAR(16) NOT NULL,
    large_date VARCHAR(30) NOT NULL,
    full_date VARCHAR(50)  NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(13) NOT NULL,
    year_description VARCHAR(4) NOT NULL,
    quarter_description VARCHAR(2) NOT NULL,
    quarter_number VARCHAR(1) NOT NULL
);

DROP TABLE IF EXISTS dim_genre;
CREATE TABLE dim_genre (
    sk_dim_genre SERIAL PRIMARY KEY,
    genre_id INT NOT NULL,
    description VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS dim_content;
CREATE TABLE dim_content (
    sk_dim_content SERIAL PRIMARY KEY,
    content_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    rating VARCHAR(8) NOT NULL,
    release_year INT NOT NULL,
    type VARCHAR(10) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    type_id INT NOT NULL,
    country_id INT NOT NULL,
    rating_id INT NOT NULL
);

DROP TABLE IF EXISTS ft_content_release;
CREATE TABLE ft_content_release (
    sk_dim_date INT NOT NULL,
    sk_dim_genre INT NOT NULL,
    sk_dim_content INT NOT NULL
);

ALTER TABLE
   ft_content_release
ADD
   PRIMARY KEY (
      sk_dim_date,
      sk_dim_genre,
      sk_dim_content
   );
   
CREATE INDEX indx1 ON ft_content_release(sk_dim_date);
CREATE INDEX indx2 ON ft_content_release(sk_dim_genre);
CREATE INDEX indx3 ON ft_content_release(sk_dim_content);