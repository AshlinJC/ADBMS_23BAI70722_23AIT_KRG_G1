
ROLLBACK; 
 
DROP TABLE IF EXISTS students; 
 
CREATE TABLE students (     
id SERIAL PRIMARY KEY,     
name VARCHAR(50) UNIQUE,     
age INT CHECK (age > 0), 
class INT CHECK (class BETWEEN 1 AND 12) 
); 
 
SELECT 'DONE CREATING TABLE' AS status; 
 
DO $$ DECLARE 
    student_row RECORD; 
BEGIN 
    RAISE NOTICE '--- BEGINNING INSERTS USING IMPLICIT SUBTRANSACTIONS ---';  
    FOR student_row IN 
        SELECT * FROM ( 
            VALUES 
                ('Ashlin', 16, 8), 
                ('Jincy',   17, 8), 
                ('Ann', 19, 9), 
                ('Alfage', 18,10),  -- duplicate name -> will fail 
                ('Adheen',  15, 7), 
                ('Wilson', -1,  5)  -- invalid age -> will fail due to CHECK 
        ) AS t(name, age, class) 
    LOOP 
        -- The inner BEGIN/EXCEPTION forms an implicit subtransaction.         
		-- If INSERT fails, only this inner block is rolled back. 
        BEGIN 
            INSERT INTO students(name, age, class) 
            VALUES (student_row.name, student_row.age, student_row.class);  
            RAISE NOTICE 'Inserted: % (age=% , class=%)', student_row.name, student_row.age, student_row.class; 
 
        EXCEPTION WHEN OTHERS THEN 
            -- The error caused the inner subtransaction to be rolled back automatically. 
            -- Log the error (do NOT re-raise) so outer transaction continues.             
			RAISE NOTICE 'Failed to insert: % | Error: %', student_row.name, SQLERRM; 
        END; 
    END LOOP; 
 
    RAISE NOTICE 'All inserts attempted. Successful inserts retained; failed ones rolled back to their subtransactions.'; 
END; 
$$; 
 
-- 3) Verify results 
SELECT * FROM students ORDER BY id;