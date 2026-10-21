/* T20 Role Patrol - Status Procedures
   Greenfield Version for Hackathon Team 20. */
SET NOCOUNT ON;
GO

CREATE OR ALTER PROCEDURE core.usp_CollectionStatus 
    @CollectionId uniqueidentifier 
AS
BEGIN 
    SET NOCOUNT ON; 
    SELECT CollectionId, Status, StartedAt, CompletedAt 
    FROM core.Collection 
    WHERE CollectionId = @CollectionId; 
END;
GO

CREATE OR ALTER PROCEDURE core.usp_RunStatus 
    @RunId uniqueidentifier 
AS
BEGIN 
    SET NOCOUNT ON; 
    SELECT RunId, Status, BusinessAsOf, CompletedAt 
    FROM core.Assessment 
    WHERE RunId = @RunId; 
END;
GO

SELECT 'Status Procedures for Team20 installed successfully.' AS Result;
GO
