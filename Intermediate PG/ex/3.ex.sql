/*
Making a Stored Procedure
In this assignment you will create a table, and add a stored procedure to it.
*/

--Create this table:
CREATE TABLE keyvalue ( 
  id SERIAL,
  key VARCHAR(128) UNIQUE,
  value VARCHAR(128) UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);
/*
Add a stored procedure so that every time a record is updated, the updated_at variable is automatically set to the current time. 

*/

--Create this stored procedure:
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

--Create this trigger:
CREATE TRIGGER update_keyvalue_updated_at BEFORE UPDATE ON keyvalue FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

/*
Add a stored procedure so that every time a record is inserted, the created_at and updated_at variables are automatically set to the current time.
*/

--Create this stored procedure:
CREATE OR REPLACE FUNCTION update_created_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.created_at = NOW();
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

--Create this trigger:
CREATE TRIGGER update_keyvalue_created_at BEFORE INSERT ON keyvalue FOR EACH ROW EXECUTE PROCEDURE update_created_at_column();
