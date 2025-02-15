CREATE TABLE Faculties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Financing MONEY NOT NULL CHECK (Financing >= 0) DEFAULT 0
);

CREATE TABLE Departments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Financing MONEY NOT NULL CHECK (Financing >= 0) DEFAULT 0,
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Teachers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL,
    Salary MONEY NOT NULL CHECK (Salary > 0)
);
CREATE TABLE Curators (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Surname NVARCHAR(MAX) NOT NULL
);

CREATE TABLE Groups (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE,
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE GroupsCurators (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

CREATE TABLE Subjects (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Lectures (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    LectureRoom NVARCHAR(MAX) NOT NULL,
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

INSERT INTO Faculties (Name, Financing) VALUES ('Computer Science', 500000), ('Mathematics', 300000);
INSERT INTO Departments (Name, Financing, FacultyId) VALUES ('Software Engineering', 200000, 1), ('Applied Mathematics', 150000, 2);
INSERT INTO Teachers (Name, Surname, Salary) VALUES ('John', 'Doe', 60000), ('Samantha', 'Adams', 70000);
INSERT INTO Curators (Name, Surname) VALUES ('Michael', 'Brown'), ('Laura', 'Smith');
INSERT INTO Groups (Name, Year, DepartmentId) VALUES ('P107', 2, 1), ('M202', 3, 2);
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES (1, 1), (2, 2);
INSERT INTO Subjects (Name) VALUES ('Database Theory'), ('Linear Algebra');
INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) VALUES ('B103', 1, 2), ('A202', 2, 1);
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES (1, 1), (2, 2);


SELECT T.Name AS TeacherName, T.Surname AS TeacherSurname, G.Name AS GroupName
FROM Teachers T CROSS JOIN Groups G;


SELECT F.Name AS FacultyName
FROM Faculties F
WHERE F.Financing < (
    SELECT SUM(D.Financing)
    FROM Departments D
    WHERE D.FacultyId = F.Id
);


SELECT C.Surname AS CuratorSurname, C.Name AS CuratorName, G.Name AS GroupName
FROM Curators C
JOIN GroupsCurators GC ON C.Id = GC.CuratorId
JOIN Groups G ON GC.GroupId = G.Id;


SELECT T.Name, T.Surname
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON GL.GroupId = G.Id
WHERE G.Name = 'P107';


SELECT T.Surname, F.Name AS FacultyName
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON GL.GroupId = G.Id
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id;

SELECT D.Name AS DepartmentName, G.Name AS GroupName
FROM Departments D
JOIN Groups G ON D.Id = G.DepartmentId;


SELECT S.Name AS SubjectName
FROM Subjects S
JOIN Lectures L ON S.Id = L.SubjectId
JOIN Teachers T ON L.TeacherId = T.Id
WHERE T.Name = 'Samantha' AND T.Surname = 'Adams';


SELECT DISTINCT D.Name AS DepartmentName
FROM Departments D
JOIN Groups G ON D.Id = G.DepartmentId
JOIN GroupsLectures GL ON G.Id = GL.GroupId
JOIN Lectures L ON GL.LectureId = L.Id
JOIN Subjects S ON L.SubjectId = S.Id
WHERE S.Name = 'вatabase Theory';


SELECT G.Name AS GroupName
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE F.Name = 'сomputer Science';

SELECT G.Name AS GroupName, F.Name AS FacultyName
FROM Groups G
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE G.Year = 5;


SELECT T.Name, T.Surname, S.Name AS SubjectName, G.Name AS GroupName
FROM Teachers T
JOIN Lectures L ON T.Id = L.TeacherId
JOIN Subjects S ON L.SubjectId = S.Id
JOIN GroupsLectures GL ON L.Id = GL.LectureId
JOIN Groups G ON GL.GroupId = G.Id
WHERE L.LectureRoom = 'B103';
