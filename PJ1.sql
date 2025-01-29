CREATE DATABASE Academy;
GO

USE Academy;
GO

CREATE TABLE Groups (
    [Id] int identity (1,1) PRIMARY KEY,
    [Name] nvarchar(10) NOT NULL UNIQUE CHECK (LEN([Name]) > 0),
    [Rating] int NOT NULL CHECK ([Rating] BETWEEN 0 AND 5),
    [Year] int NOT NULL CHECK ([Year] BETWEEN 1 AND 5)
);

CREATE TABLE Departments (
    [Id] int identity (1,1) PRIMARY KEY,
    [Financing] money NOT NULL DEFAULT 0 CHECK ([Financing] >= 0),
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0)
);

CREATE TABLE Faculties (
    [Id] int identity (1,1) PRIMARY KEY,
    [Name] nvarchar(100) NOT NULL UNIQUE CHECK (LEN([Name]) > 0)
);

CREATE TABLE Teachers (
    [Id] int identity (1,1) PRIMARY KEY,
    [EmploymentDate] DATE NOT NULL CHECK ([EmploymentDate] >= '1990-01-01'),
    [Name] nvarchar NOT NULL CHECK (LEN([Name]) > 0),
    [Premium] money NOT NULL DEFAULT 0 CHECK ([Premium] >= 0),
    [Salary] money NOT NULL CHECK ([Salary] > 0),
    [Surname] nvarchar NOT NULL CHECK (LEN([Surname]) > 0)
);