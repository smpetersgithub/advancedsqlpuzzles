---------------------------------------------
USE foo;
GO

DROP TABLE IF EXISTS dbo.tbl_example_24_child;
DROP TABLE IF EXISTS tbl_example_24_parent;
GO
---------------------------------------------
---------------------------------------------
---------------------------------------------
USE foo;
GO

CREATE TABLE tbl_example_24_parent
(
ParentID   INT PRIMARY KEY,      -- Primary Key in parent table
ParentName VARCHAR(100) NOT NULL
);
GO

CREATE TABLE tbl_example_24_child
(
ChildID INT PRIMARY KEY,       -- Primary Key in child table
ChildName NVARCHAR(100) NOT NULL,
    ParentID INT,                  -- Foreign Key column referencing ParentID in parent table
    CONSTRAINT FK_Child_Parent FOREIGN KEY (ParentID) 
    REFERENCES tbl_example_24_parent(ParentID)     -- Foreign Key constraint
);
GO

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
USE foo;
GO

DECLARE @vTruncate SMALLINT = 1;
IF @vTruncate = 1
BEGIN
     TRUNCATE TABLE foo.dbo.sql_expression_dependencies;
END;
GO

-------------------------------------------------------
USE foo;
GO

INSERT INTO foo.dbo.sql_expression_dependencies
(database_name, example_number, referencing_object_type, referencing_entity_name, referencing_id, referencing_minor_id, referencing_class, referencing_class_desc, is_schema_bound_reference, referenced_class, referenced_class_desc, referenced_server_name, referenced_database_name, referenced_schema_name, referenced_entity_name, referenced_object_type, referenced_id, referenced_minor_id, is_caller_dependent, is_ambiguous)
SELECT  'foo', '24', c.type AS referencing_object_type, c.name AS referencing_entity_name, referencing_id, referencing_minor_id, referencing_class, referencing_class_desc, is_schema_bound_reference, referenced_class, referenced_class_desc, referenced_server_name, referenced_database_name, referenced_schema_name, referenced_entity_name, b.type AS referenced_object_type, referenced_id, referenced_minor_id, is_caller_dependent, is_ambiguous
FROM    sys.sql_expression_dependencies a LEFT OUTER JOIN
        sys.objects b ON a.referenced_id = b.object_id LEFT OUTER JOIN
        sys.objects c ON a.referencing_id = c.object_id;
GO

-------------------------------------------------------
SELECT * FROM foo.dbo.sql_expression_dependencies ORDER BY example_number;
GO

---------------------------------------------
USE foo;
GO

DECLARE @vDropObjects SMALLINT = 1;
IF @vDropObjects = 1
BEGIN
     DROP TABLE IF EXISTS dbo.tbl_example_24_child;
     DROP TABLE IF EXISTS tbl_example_24_parent;
END;
GO