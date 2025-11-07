--MEDIUM LEVEL PROBLEM
CREATE TABLE IF NOT EXISTS student (     
id SERIAL PRIMARY KEY,     
name VARCHAR(100),     
age INT,     
class VARCHAR(20) 
); 
 
CREATE OR REPLACE FUNCTION fn_student_audit() 
RETURNS TRIGGER 
LANGUAGE plpgsql 
AS $$ 
BEGIN 
    IF TG_OP = 'INSERT' THEN 
        RAISE NOTICE 'Inserted Row -> ID: %, Name: %, Age: %, Class: %', 
                     NEW.id, NEW.name, NEW.age, NEW.class; 
        RETURN NEW; 
 
    ELSIF TG_OP = 'DELETE' THEN 
        RAISE NOTICE 'Deleted Row -> ID: %, Name: %, Age: %, Class: %', 
                     OLD.id, OLD.name, OLD.age, OLD.class; 
        RETURN OLD; 
    END IF; 
 
    RETURN NULL; 
END; 
$$; 
 
DROP TRIGGER IF EXISTS trg_student_audit ON student; 
 
CREATE TRIGGER trg_student_audit 
AFTER INSERT OR DELETE 
ON student 
FOR EACH ROW 
EXECUTE FUNCTION fn_student_audit(); 
 
-- Insert 
INSERT INTO student (name, age, class) VALUES ('Ashlin', 21, '12th'); 
 
 
-- Delete 
DELETE FROM student WHERE name = 'Ashlin';

--HARD LEVEL PROBLEM

CREATE TABLE IF NOT EXISTS tbl_employee (     
emp_id SERIAL PRIMARY KEY,     
emp_name VARCHAR(100) NOT NULL,     
emp_salary NUMERIC 
); 
 
CREATE TABLE IF NOT EXISTS tbl_employee_audit (     
sno SERIAL PRIMARY KEY,     
message TEXT NOT NULL 
); 
 
CREATE OR REPLACE FUNCTION audit_employee_changes() 
RETURNS TRIGGER 
LANGUAGE plpgsql 
AS $$ 
BEGIN 
    IF TG_OP = 'INSERT' THEN 
        INSERT INTO tbl_employee_audit(message) 
        VALUES ('Employee name ' || NEW.emp_name || ' has been added at ' || NOW()); 
        RETURN NEW; 
 
    ELSIF TG_OP = 'DELETE' THEN 
        INSERT INTO tbl_employee_audit(message) 
        VALUES ('Employee name ' || OLD.emp_name || ' has been deleted at ' || NOW()); 
        RETURN OLD; 
    END IF; 
 
    RETURN NULL; 
END; 
$$; 
 
DROP TRIGGER IF EXISTS trg_employee_audit ON tbl_employee; 
 
CREATE TRIGGER trg_employee_audit 
AFTER INSERT OR DELETE 
ON tbl_employee 
FOR EACH ROW 
EXECUTE FUNCTION audit_employee_changes(); 
 
-- Insert and verify audit 
INSERT INTO tbl_employee (emp_name, emp_salary) VALUES ('Ashlin', 40000); 
SELECT * FROM tbl_employee_audit; 
 
-- Delete and verify audit 
DELETE FROM tbl_employee WHERE emp_name = 'Ashlin'; 
SELECT * FROM tbl_employee_audit;