IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'team20-adf-204508')
BEGIN
    CREATE USER [team20-adf-204508] FROM EXTERNAL PROVIDER;
    ALTER ROLE db_datareader ADD MEMBER [team20-adf-204508];
    ALTER ROLE db_datawriter ADD MEMBER [team20-adf-204508];
    GRANT EXECUTE TO [team20-adf-204508];
END
GO
