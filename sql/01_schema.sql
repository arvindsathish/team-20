/* T20 Role Patrol - Clean Greenfield DDL Schema
   Designed for Hackathon Team 20.
   Pure DDL definitions with varchar(16) employee IDs.
   Zero legacy mock seeds included. */
SET XACT_ABORT ON;
GO

IF OBJECT_ID('src.Employee') IS NOT NULL THROW 51000,'Schema already exists. Use a clean database or documented reset.',1;
GO

CREATE SCHEMA src AUTHORIZATION dbo;
GO
CREATE SCHEMA core AUTHORIZATION dbo;
GO
CREATE SCHEMA casework AUTHORIZATION dbo;
GO
CREATE SCHEMA api AUTHORIZATION dbo;
GO
CREATE SCHEMA audit AUTHORIZATION dbo;
GO
CREATE SCHEMA scenario AUTHORIZATION dbo;
GO
CREATE SCHEMA eval AUTHORIZATION dbo;
GO

-- 1. Source System Tables (populated by Import-HackathonDatasets.ps1)
CREATE TABLE src.Role(
    RoleId varchar(24) PRIMARY KEY,
    JobTitle nvarchar(80) NOT NULL,
    CostCenter varchar(12) NOT NULL,
    Country char(2) NOT NULL,
    OwnerEmployeeId varchar(16) NOT NULL
);

CREATE TABLE src.RoleVersion(
    VersionId varchar(32) PRIMARY KEY,
    RoleId varchar(24) NOT NULL REFERENCES src.Role,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NULL
);

CREATE TABLE src.Entitlement(
    EntitlementId varchar(24) PRIMARY KEY,
    DisplayName nvarchar(80) NOT NULL,
    Risk varchar(10) NOT NULL,
    ContextCode varchar(12) NOT NULL
);

CREATE TABLE src.RoleEntitlement(
    VersionId varchar(32) NOT NULL REFERENCES src.RoleVersion,
    EntitlementId varchar(24) NOT NULL REFERENCES src.Entitlement,
    PRIMARY KEY(VersionId,EntitlementId)
);

CREATE TABLE src.Employee(
    EmployeeId varchar(16) PRIMARY KEY,
    DisplayName nvarchar(80) NOT NULL,
    Email nvarchar(100) NOT NULL,
    Active bit NOT NULL DEFAULT 1
);

CREATE TABLE src.Move(
    EventId varchar(16) PRIMARY KEY,
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    FromVersion varchar(32) NOT NULL REFERENCES src.RoleVersion,
    ToVersion varchar(32) NOT NULL REFERENCES src.RoleVersion,
    EffectiveAt datetime2 NOT NULL
);

CREATE TABLE src.Assignment(
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    VersionId varchar(32) NOT NULL REFERENCES src.RoleVersion,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NULL,
    AssignmentStatus varchar(10) NOT NULL,
    PRIMARY KEY(EmployeeId,VersionId,ValidFrom)
);

CREATE TABLE src.Ticket(
    TicketId varchar(16) PRIMARY KEY,
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    OpenedAt datetime2 NOT NULL,
    ResolvedAt datetime2 NULL,
    TicketType varchar(32) NOT NULL,
    TicketText nvarchar(1000) NOT NULL,
    EntitlementId varchar(24) NULL REFERENCES src.Entitlement,
    CanonicalRoot varchar(16) NOT NULL,
    MatchMethod varchar(16) NOT NULL,
    ContextCode varchar(12) NOT NULL,
    CONSTRAINT FK_TicketRoot FOREIGN KEY(CanonicalRoot) REFERENCES src.Ticket
);

CREATE TABLE src.Origin(
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    EntitlementId varchar(24) NOT NULL REFERENCES src.Entitlement,
    OriginType varchar(20) NOT NULL,
    OriginVersion varchar(32) NULL REFERENCES src.RoleVersion,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NULL
);

CREATE TABLE src.Exception(
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    EntitlementId varchar(24) NOT NULL REFERENCES src.Entitlement,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    Approved bit NOT NULL,
    PRIMARY KEY(EmployeeId,EntitlementId,ValidFrom)
);

CREATE TABLE src.Coverage(
    EmployeeId varchar(16) PRIMARY KEY REFERENCES src.Employee,
    ProvenanceComplete bit NOT NULL,
    ExceptionsComplete bit NOT NULL
);

CREATE TABLE src.ExpectedMember(
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    EntitlementId varchar(24) NOT NULL REFERENCES src.Entitlement,
    PRIMARY KEY(EmployeeId,EntitlementId)
);

CREATE TABLE src.IdentityMap(
    EmployeeId varchar(16) PRIMARY KEY REFERENCES src.Employee,
    ObjectId uniqueidentifier NOT NULL UNIQUE
);

CREATE TABLE src.GroupMap(
    EntitlementId varchar(24) PRIMARY KEY REFERENCES src.Entitlement,
    ObjectId uniqueidentifier NOT NULL UNIQUE
);

CREATE TABLE src.SourceStatus(
    DomainName varchar(16) PRIMARY KEY,
    Complete bit NOT NULL,
    CheckedAt datetime2 NOT NULL
);

-- 2. Core Governance Engine Tables
CREATE TABLE core.Principal(
    DbUser sysname PRIMARY KEY,
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee
);

CREATE TABLE core.Permission(
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    RoleId varchar(24) NOT NULL REFERENCES src.Role,
    CanReadDetail bit NOT NULL,
    CanDecide bit NOT NULL,
    CanIam bit NOT NULL DEFAULT 0,
    PRIMARY KEY(EmployeeId,RoleId)
);

CREATE TABLE core.Collection(
    CollectionId uniqueidentifier PRIMARY KEY,
    StartedAt datetime2 NOT NULL,
    CompletedAt datetime2 NULL,
    Mode varchar(16) NOT NULL,
    Status varchar(16) NOT NULL
);

CREATE TABLE core.CollectionGroup(
    CollectionId uniqueidentifier NOT NULL REFERENCES core.Collection,
    EntitlementId varchar(24) NOT NULL REFERENCES src.Entitlement,
    Status varchar(16) NOT NULL,
    Pages int NOT NULL,
    PRIMARY KEY(CollectionId,EntitlementId)
);

CREATE TABLE core.Member(
    CollectionId uniqueidentifier NOT NULL REFERENCES core.Collection,
    EmployeeId varchar(16) NOT NULL REFERENCES src.Employee,
    EntitlementId varchar(24) NOT NULL REFERENCES src.Entitlement,
    PRIMARY KEY(CollectionId,EmployeeId,EntitlementId)
);

CREATE TABLE core.Assessment(
    RunId uniqueidentifier PRIMARY KEY,
    BusinessAsOf datetime2 NOT NULL,
    StartedAt datetime2 NOT NULL,
    CompletedAt datetime2 NULL,
    CollectionId uniqueidentifier NULL REFERENCES core.Collection,
    Status varchar(16) NOT NULL,
    RuleVersion varchar(32) NOT NULL,
    SourceJson nvarchar(max) NOT NULL CHECK(ISJSON(SourceJson)=1)
);

CREATE TABLE core.Published(
    StreamId int PRIMARY KEY CHECK(StreamId=1),
    RunId uniqueidentifier NOT NULL REFERENCES core.Assessment
);

CREATE TABLE core.Impact(
    RunId uniqueidentifier NOT NULL REFERENCES core.Assessment,
    RoleId varchar(24) NOT NULL REFERENCES src.Role,
    AffectedEmployees int NOT NULL,
    EligibleEvents int NOT NULL,
    TransferredEmployees int NOT NULL,
    AffectedEvents int NOT NULL,
    RawTickets int NOT NULL,
    CanonicalTickets int NOT NULL,
    Coverage varchar(16) NOT NULL,
    PRIMARY KEY(RunId,RoleId)
);

CREATE TABLE core.Evidence(
    RunId uniqueidentifier NOT NULL REFERENCES core.Assessment,
    RoleId varchar(24) NOT NULL,
    EmployeeId varchar(16) NOT NULL,
    EmployeeName nvarchar(80) NOT NULL,
    EventId varchar(16) NOT NULL,
    ToVersion varchar(32) NOT NULL,
    TicketId varchar(16) NOT NULL,
    CanonicalRoot varchar(16) NOT NULL,
    EntitlementId varchar(24) NOT NULL,
    TicketText nvarchar(1000) NOT NULL,
    OpenedAt datetime2 NOT NULL,
    ResolvedAt datetime2 NULL,
    PRIMARY KEY(RunId,TicketId)
);

CREATE TABLE core.Transfer(
    RunId uniqueidentifier NOT NULL REFERENCES core.Assessment,
    EventId varchar(16) NOT NULL,
    EmployeeId varchar(16) NOT NULL,
    TargetRole varchar(24) NOT NULL,
    EffectiveAt datetime2 NOT NULL,
    EntitlementId varchar(24) NOT NULL,
    Prediction varchar(30) NOT NULL,
    Reason nvarchar(400) NOT NULL,
    PRIMARY KEY(RunId,EventId,EntitlementId)
);

CREATE TABLE core.Peer(
    RunId uniqueidentifier NOT NULL REFERENCES core.Assessment,
    RoleId varchar(24) NOT NULL,
    EntitlementId varchar(24) NOT NULL,
    ObservedPeers int NOT NULL,
    Holders int NOT NULL,
    Quality varchar(16) NOT NULL,
    PRIMARY KEY(RunId,RoleId,EntitlementId)
);

-- 3. Casework, Audit & Scenario Tables
CREATE TABLE casework.ReviewCase(
    CaseId int IDENTITY PRIMARY KEY,
    RoleId varchar(24) NOT NULL,
    EntitlementId varchar(24) NOT NULL,
    EmployeeId varchar(16) NOT NULL,
    OwnerEmployeeId varchar(16) NOT NULL,
    RunId uniqueidentifier NOT NULL REFERENCES core.Assessment,
    Status varchar(32) NOT NULL,
    CaseVersion int NOT NULL,
    DueAt datetime2 NOT NULL,
    ExternalReference nvarchar(200) NULL,
    UNIQUE(RoleId,EntitlementId,EmployeeId)
);

CREATE TABLE casework.Decision(
    DecisionId uniqueidentifier PRIMARY KEY,
    CaseId int NOT NULL REFERENCES casework.ReviewCase,
    Actor varchar(16) NOT NULL,
    Decision varchar(32) NOT NULL,
    Rationale nvarchar(1000) NOT NULL,
    RunId uniqueidentifier NOT NULL,
    IdempotencyKey uniqueidentifier NOT NULL UNIQUE,
    RequestHash varbinary(32) NOT NULL,
    CreatedAt datetime2 NOT NULL,
    DecisionMode varchar(24) NOT NULL
);

CREATE TABLE audit.Event(
    AuditId bigint IDENTITY PRIMARY KEY,
    Actor nvarchar(128) NOT NULL,
    ActionName varchar(40) NOT NULL,
    ObjectId nvarchar(100) NOT NULL,
    Detail nvarchar(2000) NOT NULL,
    CreatedAt datetime2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE scenario.Result(
    ScenarioId uniqueidentifier PRIMARY KEY,
    Actor varchar(16) NOT NULL,
    RunId uniqueidentifier NOT NULL,
    RoleId varchar(24) NOT NULL,
    CreatedAt datetime2 NOT NULL,
    ResultJson nvarchar(max) NOT NULL CHECK(ISJSON(ResultJson)=1)
);

CREATE TABLE core.MatchCandidate(
    CandidateId int IDENTITY PRIMARY KEY,
    TicketId varchar(16) NOT NULL,
    EntitlementId varchar(24) NOT NULL,
    Relevance float NULL,
    Status varchar(16) NOT NULL,
    ConfirmedBy varchar(16) NULL,
    ConfirmedAt datetime2 NULL
);

CREATE TABLE casework.Outcome(
    OutcomeId int IDENTITY PRIMARY KEY,
    CaseId int NOT NULL REFERENCES casework.ReviewCase,
    OutcomeType varchar(32) NOT NULL,
    EvidenceReference nvarchar(300) NOT NULL,
    VerifiedBy varchar(16) NOT NULL,
    CreatedAt datetime2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Performance Indexes
CREATE INDEX IX_Move_EmployeeTime ON src.Move(EmployeeId,EffectiveAt);
CREATE INDEX IX_Ticket_EmployeeTime ON src.Ticket(EmployeeId,OpenedAt);
CREATE INDEX IX_Evidence_RoleRun ON core.Evidence(RunId,RoleId,EmployeeId);
GO

SELECT 'Greenfield DDL Schema for Team20 installed successfully.' AS Result;
GO
