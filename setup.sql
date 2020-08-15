CREATE TABLE score_list (
  id INT NOT NULL,
  works_id VARCHAR(8) NOT NULL,
  title VARCHAR(128) NOT NULL,
  creator VARCHAR(64) NOT NULL,
  key_type VARCHAR(8) NOT NULL,
  level_name VARCHAR(32) NOT NULL,
  duration INT NOT NULL,
  notes INT NOT NULL,
  difficulty FLOAT NOT NULL,
  event_flg VARCHAR(16) DEFAULT NULL,
  page_url VARCHAR(256) DEFAULT NULL,
  adjustment INT DEFAULT 0
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

-- LOAD DATA LOCAL INFILE "../../Downloads/score_list.tsv"
-- INTO TABLE score_list
-- FIELDS TERMINATED BY '\t';
