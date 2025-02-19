SELECT Building
FROM Departments
GROUP BY Building
HAVING SUM(Financing) > 100000;


SELECT g.Name
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
WHERE d.Name = 'Software Development'
AND g.Year = 5
AND (SELECT COUNT(*) 
     FROM Lectures 
     WHERE Date BETWEEN '2025-01-01' AND '2025-01-07' AND GroupId = g.Id) > 10;


SELECT g.Name
FROM Groups g
JOIN GroupsStudents gs ON g.Id = gs.GroupId
JOIN Students s ON gs.StudentId = s.Id
GROUP BY g.Name
HAVING AVG(s.Rating) > 
    (SELECT AVG(s2.Rating)
     FROM GroupsStudents gs2
     JOIN Students s2 ON gs2.StudentId = s2.Id
     JOIN Groups g2 ON gs2.GroupId = g2.Id
     WHERE g2.Name = 'D221');


SELECT t.Surname, t.Name
FROM Teachers t
WHERE t.Salary > (SELECT AVG(Salary) FROM Teachers WHERE IsProfessor = 1);


SELECT g.Name
FROM Groups g
JOIN GroupsCurators gc ON g.Id = gc.GroupId
GROUP BY g.Name
HAVING COUNT(gc.CuratorId) > 1;

SELECT g.Name
FROM Groups g
JOIN GroupsStudents gs ON g.Id = gs.GroupId
JOIN Students s ON gs.StudentId = s.Id
GROUP BY g.Name
HAVING AVG(s.Rating) < 
    (SELECT MIN(s2.Rating)
     FROM GroupsStudents gs2
     JOIN Students s2 ON gs2.StudentId = s2.Id
     JOIN Groups g2 ON gs2.GroupId = g2.Id
     WHERE g2.Year = 5);

SELECT f.Name
FROM Faculties f
JOIN Departments d ON f.Id = d.FacultyId
GROUP BY f.Name
HAVING SUM(d.Financing) > 
    (SELECT SUM(d2.Financing)
     FROM Departments d2
     JOIN Faculties f2 ON d2.FacultyId = f2.Id
     WHERE f2.Name = 'Computer Science');


SELECT sub.Name AS Subject, 
       t.Name + ' ' + t.Surname AS Teacher
FROM Lectures l
JOIN Subjects sub ON l.SubjectId = sub.Id
JOIN Teachers t ON l.TeacherId = t.Id
GROUP BY sub.Name, t.Name, t.Surname
HAVING COUNT(l.Id) = 
    (SELECT MAX(lecture_count)
     FROM (SELECT COUNT(l2.Id) AS lecture_count
           FROM Lectures l2
           WHERE l2.SubjectId = l.SubjectId
           GROUP BY l2.TeacherId) AS lecture_counts);

SELECT sub.Name
FROM Subjects sub
JOIN Lectures l ON sub.Id = l.SubjectId
GROUP BY sub.Name
HAVING COUNT(l.Id) = 
    (SELECT MIN(lecture_count)
     FROM (SELECT COUNT(l2.Id) AS lecture_count
           FROM Lectures l2
           GROUP BY l2.SubjectId) AS lecture_counts);



FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
JOIN GroupsStudents gs ON g.Id = gs.GroupId
JOIN Students s ON gs.StudentId = s.Id
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
WHERE d.Name = 'Software Development';
