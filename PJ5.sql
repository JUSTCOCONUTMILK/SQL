CREATE TABLE s_Group (
    GroupId INT PRIMARY KEY IDENTITY,
    GroupName NVARCHAR(100) NOT NULL,
    StudentsCount INT DEFAULT 0
);

CREATE TABLE Student (
    StudentId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    GroupId INT FOREIGN KEY REFERENCES [Group](GroupId)
);

CREATE TABLE Course (
    CourseId INT PRIMARY KEY IDENTITY,
    CourseName NVARCHAR(100) NOT NULL
);

CREATE TABLE Enrollment (
    StudentId INT FOREIGN KEY REFERENCES Student(StudentId),
    CourseId INT FOREIGN KEY REFERENCES Course(CourseId),
    PRIMARY KEY (StudentId, CourseId)
);

CREATE TABLE Grade (
    GradeId INT PRIMARY KEY IDENTITY,
    StudentId INT FOREIGN KEY REFERENCES Student(StudentId),
    CourseId INT FOREIGN KEY REFERENCES Course(CourseId),
    Score INT NOT NULL
);

CREATE TABLE Warnings (
    WarningId INT PRIMARY KEY IDENTITY,
    StudentId INT FOREIGN KEY REFERENCES Student(StudentId),
    Reason NVARCHAR(255) NOT NULL,
    WarningDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Teacher (
    TeacherId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE CourseTeacher (
    CourseId INT FOREIGN KEY REFERENCES Course(CourseId),
    TeacherId INT FOREIGN KEY REFERENCES Teacher(TeacherId),
    PRIMARY KEY (CourseId, TeacherId)
);

CREATE TABLE GradeHistory (
    HistoryId INT PRIMARY KEY IDENTITY,
    GradeId INT,
    OldScore INT,
    ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Attendance (
    AttendanceId INT PRIMARY KEY IDENTITY,
    StudentId INT FOREIGN KEY REFERENCES Student(StudentId),
    AttendanceDate DATE NOT NULL
);

CREATE TABLE RetakeList (
    StudentId INT FOREIGN KEY REFERENCES Student(StudentId) PRIMARY KEY
);

CREATE TABLE Payments (
    PaymentId INT PRIMARY KEY IDENTITY,
    StudentId INT FOREIGN KEY REFERENCES Student(StudentId),
    Amount DECIMAL(10,2),
    PaymentStatus NVARCHAR(50) NOT NULL
);

CREATE TRIGGER trg_LimitStudentsInGroup
ON Student
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM s_Group
        WHERE GroupId IN (SELECT GroupId FROM inserted)
          AND StudentsCount >= 30
    )
    BEGIN
        ROLLBACK;
    END
END;

CREATE TRIGGER trg_UpdateStudentsCount
ON Student
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE s_Group
    SET StudentsCount = (SELECT COUNT(*) FROM Student WHERE Student.GroupId = s_Group.GroupId)
    WHERE GroupId IN (SELECT GroupId FROM inserted);
END;

CREATE TRIGGER trg_AutoEnrollStudent
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO Enrollment (StudentId, CourseId)
    SELECT StudentId, (SELECT CourseId FROM Course WHERE CourseName = 'Введение в программирование')
    FROM inserted
    WHERE EXISTS (SELECT 1 FROM Course WHERE CourseName = 'Введение в программирование');
END;

CREATE TRIGGER trg_WarningLowGrade
ON Grade
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO Warnings (StudentId, Reason)
    SELECT StudentId, ''
    FROM inserted
    WHERE Score < 3;
END;

CREATE TRIGGER trg_ProtectTeachers
ON Teacher
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM CourseTeacher
        WHERE TeacherId IN (SELECT TeacherId FROM deleted)
    )
    BEGIN
        ROLLBACK;
    END
    ELSE
    BEGIN
        DELETE FROM Teacher WHERE TeacherId IN (SELECT TeacherId FROM deleted);
    END
END;

CREATE TRIGGER trg_GradeHistory
ON Grade
AFTER UPDATE
AS
BEGIN
    INSERT INTO GradeHistory (GradeId, OldScore, ChangeDate)
    SELECT GradeId, Score, GETDATE()
    FROM deleted;
END;

CREATE TRIGGER trg_AttendanceCheck
ON Attendance
AFTER INSERT
AS
BEGIN
    INSERT INTO RetakeList (StudentId)
    SELECT StudentId
    FROM Attendance
    WHERE AttendanceDate >= DATEADD(DAY, -5, GETDATE())
    GROUP BY StudentId
    HAVING COUNT(*) >= 5;
END;

CREATE TRIGGER trg_ProtectStudents
ON Student
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Payments
        WHERE StudentId IN (SELECT StudentId FROM deleted) AND PaymentStatus != 'Оплачено'
    )
    BEGIN
        ROLLBACK;
    END
    ELSE
    BEGIN
        DELETE FROM Student WHERE StudentId IN (SELECT StudentId FROM deleted);
    END
END;

CREATE TRIGGER trg_UpdateAverageScore
ON Grade
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE Student
    SET AverageScore = (SELECT AVG(Score) FROM Grade WHERE Grade.StudentId = Student.StudentId)
    WHERE StudentId IN (SELECT StudentId FROM inserted);
END;
