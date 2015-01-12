USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'MaidLikeNew')
  DROP DATABASE MaidLikeNew
GO

CREATE DATABASE MaidLikeNew
GO

ALTER DATABASE MaidLikeNew SET RECOVERY SIMPLE
GO

USE MaidLikeNew
GO

IF OBJECT_ID('MaidLikeNew.dbo.Client') IS NOT NULL
  DROP TABLE dbo.Client

CREATE TABLE dbo.Client (
    ClientID INT NOT NULL IDENTITY,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	CanText BIT NOT NULL CONSTRAINT DF_Client_CanText DEFAULT 0,
	CanFacebook BIT NOT NULL CONSTRAINT DF_Client_CanFacebook DEFAULT 0,
	QuotedRate VARCHAR(1000) NOT NULL CONSTRAINT DF_Client_QuotedRate DEFAULT '',
	CONSTRAINT PK_Client PRIMARY KEY (ClientID)
)
GO

CREATE NONCLUSTERED INDEX IX_Client_LastName ON Client(LastName)
GO

IF OBJECT_ID('MaidLikeNew.dbo.Address') IS NOT NULL
  DROP TABLE dbo.Address

CREATE TABLE Address (
  AddressID INT NOT NULL IDENTITY,
  Line1 VARCHAR(256) NOT NULL,
  Line2 VARCHAR(256) NOT NULL,
  City VARCHAR(256) NOT NULL,
  State VARCHAR(2) NOT NULL,
  ZIP VARCHAR(9) NOT NULL,
  CONSTRAINT PK_Address PRIMARY KEY(AddressID)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.ClientAddress') IS NOT NULL
  DROP TABLE dbo.ClientAddress
GO

CREATE TABLE ClientAddress (
  ClientID INT NOT NULL,
  AddressID INT NOT NULL,
  CONSTRAINT PK_ClientAddress PRIMARY KEY (ClientID, AddressID),
  CONSTRAINT FK_ClientAddress_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_ClientAddress_Address FOREIGN KEY (AddressID) REFERENCES dbo.Address (AddressID)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.PhoneType') IS NOT NULL
  DROP TABLE dbo.PhoneType
GO

CREATE TABLE dbo.PhoneType (
  PhoneTypeCode CHAR(1) NOT NULL,
  PhoneTypeDescription VARCHAR(24) NOT NULL,
  CONSTRAINT PK_PhoneType PRIMARY KEY (PhoneTypeCode)
)
GO

INSERT INTO PhoneType (PhoneTypeCode, PhoneTypeDescription) VALUES ('H', 'Home')
INSERT INTO PhoneType (PhoneTypeCode, PhoneTypeDescription) VALUES ('W', 'Work')
INSERT INTO PhoneType (PhoneTypeCode, PhoneTypeDescription) VALUES ('M', 'Mobile')
GO

IF OBJECT_ID('MaidLikeNew.dbo.Phone') IS NOT NULL
  DROP TABLE dbo.Phone
GO

CREATE TABLE dbo.Phone (
  PhoneID INT NOT NULL IDENTITY,
  PhoneNumber VARCHAR(24) NOT NULL,
  Extension VARCHAR(10) NULL,
  PhoneTypeCode CHAR(1) NOT NULL,
  CONSTRAINT PK_Phone PRIMARY KEY (PhoneID),
  CONSTRAINT FK_Phone_PhoneType FOREIGN KEY (PhoneTypeCode) REFERENCES dbo.PhoneType (PhoneTypeCode)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.ClientPhone') IS NOT NULL
  DROP TABLE dbo.ClientPhone
GO

CREATE TABLE dbo.ClientPhone (
  ClientID INT NOT NULL,
  PhoneID INT NOT NULL,
  CONSTRAINT PK_ClientPhone PRIMARY KEY (ClientID, PhoneID),
  CONSTRAINT FK_ClientPhone_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_ClientPhone_Phone FOREIGN KEY (PhoneID) REFERENCES dbo.Phone (PhoneID)
)
GO

IF OBJECT_ID('MaidLineNew.dbo.Email') IS NOT NULL
  DROP TABLE dbo.Email
GO

CREATE TABLE dbo.Email (
  EmailID INT NOT NULL IDENTITY,
  EmailAddress VARCHAR(124) NOT NULL,
  CONSTRAINT PK_Email PRIMARY KEY (EmailID)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.ClientEmail') IS NOT NULL
  DROP TABLE dbo.ClientEmail
GO

CREATE TABLE ClientEmail (
  ClientID INT NOT NULL,
  EmailID INT NOT NULL,
  CONSTRAINT PK_ClientEmail PRIMARY KEY (ClientID, EmailID),
  CONSTRAINT FK_ClientEmail_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_ClientEmail_Email FOREIGN KEY (EmailID) REFERENCES dbo.Email (EmailID)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.PetType') IS NOT NULL
  DROP TABLE dbo.PetType
GO

CREATE TABLE PetType (
  PetTypeCode CHAR(1) NOT NULL,
  PetTypeDescription VARCHAR(64) NOT NULL,
  CONSTRAINT PK_PetType PRIMARY KEY (PetTypeCode)
)
GO

INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('D', 'Dog')
INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('C', 'Cat')
INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('B', 'Bird')
INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('L', 'Lizard')
INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('F', 'Fish')
INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('O', 'Orangutan')
INSERT INTO PetType (PetTypeCode, PetTypeDescription) VALUES ('M', 'Marmot')
GO

IF OBJECT_ID('MaidLikeNew.dbo.Pet') IS NOT NULL
  DROP TABLE Pet
GO

CREATE TABLE Pet (
  ClientID INT NOT NULL,
  PetTypeCode CHAR(1) NOT NULL,
  PetName VARCHAR(32) NOT NULL,
  CONSTRAINT PK_Pet PRIMARY KEY (ClientID, PetTypeCode, PetName),
  CONSTRAINT FK_Pet_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_Pet_PetType FOREIGN KEY (PetTypeCode) REFERENCES dbo.PetType (PetTypeCode)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.CleanType') IS NOT NULL
  DROP TABLE dbo.CleanType
GO

CREATE TABLE dbo.CleanType (
  CleanTypeCode CHAR(2) NOT NULL,
  CleanTypeDescription VARCHAR(64) NOT NULL,
  CONSTRAINT PK_CleaningType PRIMARY KEY (CleanTypeCode)
)
GO

INSERT INTO dbo.CleanType (CleanTypeCode, CleanTypeDescription) VALUES ('dc', 'Deep Clean')
INSERT INTO dbo.CleanType (CleanTypeCode, CleanTypeDescription) VALUES ('bw', 'Bi-Weekly')
INSERT INTO dbo.CleanType (CleanTypeCode, CleanTypeDescription) VALUES ('mo', 'Monthly')
INSERT INTO dbo.CleanType (CleanTypeCode, CleanTypeDescription) VALUES ('gc', 'Gift Certificate')
INSERT INTO dbo.CleanType (CleanTypeCode, CleanTypeDescription) VALUES ('ot', 'Other')
GO

IF OBJECT_ID('MaidLikeNew.dbo.Clean') IS NOT NULL
  DROP TABLE dbo.Clean
GO

CREATE TABLE dbo.Clean (
  ClientID INT NOT NULL,
  CleanDate DATE NOT NULL,
  CleanTime TIME NOT NULL,
  CleanTypeCode CHAR(2) NOT NULL,
  Rate MONEY NOT NULL CONSTRAINT DF_Clean_Rate DEFAULT 0,
  CONSTRAINT PK_Clean PRIMARY KEY (ClientID, CleanDate, CleanTime),
  CONSTRAINT FK_Clean_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_Clean_CleanType FOREIGN KEY (CleanTypeCode) REFERENCES CleanType (CleanTypeCode)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.Assessment') IS NOT NULL
  DROP TABLE dbo.Assessment
GO

CREATE TABLE Assessment (
  AssessmentID INT NOT NULL IDENTITY,
  ClientID INT NOT NULL,
  CompletedAt DATE NULL,
  Note VARCHAR(MAX) NULL,
  CONSTRAINT PK_Assessment PRIMARY KEY (AssessmentID),
  CONSTRAINT FK_Assessment_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.Employee') IS NOT NULL
  DROP TABLE MaidLikeNew.dbo.Staff
GO

CREATE TABLE dbo.Employee (
  EmployeeID INT NOT NULL IDENTITY,
  Name VARCHAR(100) NOT NULL,
  CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID)
)
GO

INSERT INTO dbo.Employee(Name) VALUES ('Mackensie')
INSERT INTO dbo.Employee(Name) VALUES ('Ashley')
INSERT INTO dbo.Employee(Name) VALUES ('K-Payne')
GO

IF OBJECT_ID('MaidLikeNew.dbo.ClientEmployee') IS NOT NULL
  DROP TABLE dbo.ClientEmployee
GO

CREATE TABLE ClientEmployee (
  ClientID INT NOT NULL,
  EmployeeID INT NOT NULL,
  CONSTRAINT PK_ClientEmployee PRIMARY KEY (ClientID, EmployeeID),
  CONSTRAINT FK_ClientEmployee_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_ClientEmployee_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee (EmployeeID)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.NoteType') IS NOT NULL
  DROP TABLE dbo.NoteType
GO

CREATE TABLE dbo.NoteType (
  NoteTypeCode CHAR(1) NOT NULL,
  NoteTypeDescription VARCHAR(20) NOT NULL,
  CONSTRAINT PK_NoteType PRIMARY KEY (NoteTypeCode)
)
GO

INSERT INTO dbo.NoteType(NoteTypeCode, NoteTypeDescription) VALUES ('n', 'Note')
INSERT INTO dbo.NoteType(NoteTypeCode, NoteTypeDescription) VALUES ('s', 'Special Request')
GO

IF OBJECT_ID('MaidLikeNew.dbo.Note') IS NOT NULL
  DROP TABLE dbo.Note
GO

CREATE TABLE dbo.Note (
  NoteID INT NOT NULL IDENTITY,
  NoteTypeCode CHAR(1),
  NoteText VARCHAR(MAX) NOT NULL CONSTRAINT DF_Note_NoteText DEFAULT '',
  CONSTRAINT PK_Note PRIMARY KEY (NoteID),
  CONSTRAINT FK_Note_NoteType FOREIGN KEY (NoteTypeCode) REFERENCES dbo.NoteType (NoteTypeCode)
)
GO

IF OBJECT_ID('MaidLikeNew.dbo.ClientNote') IS NOT NULL
  DROP TABLE dbo.ClientNote
GO

CREATE TABLE dbo.ClientNote (
  ClientID INT NOT NULL,
  NoteID INT NOT NULL,
  CONSTRAINT PK_ClientNote PRIMARY KEY (ClientID, NoteID),
  CONSTRAINT FK_ClientNote_Client FOREIGN KEY (ClientID) REFERENCES dbo.Client (ClientID),
  CONSTRAINT FK_ClientNote_Note FOREIGN KEY (NoteID) REFERENCES dbo.Note (NoteID)
)
GO
