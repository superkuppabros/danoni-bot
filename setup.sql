CREATE TABLE score_list (
  id INT NOT NULL,
  title VARCHAR(128) NOT NULL,
  creator VARCHAR(64) NOT NULL,
  key_type VARCHAR(8) NOT NULL,
  level_name VARCHAR(32) NOT NULL,
  duration INT NOT NULL,
  notes_num INT NOT NULL,
  difficulty INT NOT NULL,
  event_flg VARCHAR(16) DEFAULT NULL,
  page_url VARCHAR(256) DEFAULT NULL
);

CREATE TABLE card_list (
  id INT NOT NULL,
  name VARCHAR(32) NOT NULL,
  possibility INT NOT NULL,
  attribute VARCHAR(8) NOT NULL,
  explanation VARCHAR(1024) DEFAULT NULL
);

-- LOAD DATA LOCAL INFILE "../../Downloads/card_list.csv"
-- INTO TABLE card_list 
-- FIELDS TERMINATED BY ',';
