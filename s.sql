CREATE TRIGGER trg_one
ON Cars
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO CarPriceHistory (CarId, OldPrice, NewPrice, ChangeDate)
        SELECT i.Id, d.Price, i.Price, GETDATE()
        FROM inserted i
        JOIN deleted d ON i.Id = d.Id;
    END
END;


CREATE TRIGGER trg_two
ON Customers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM deleted d
        JOIN Orders o ON d.Id = o.CustomerId
    )
    BEGIN
        RAISERROR ('nuhuh', 16, 1);
        RETURN;
    END
    DELETE FROM Customers WHERE Id IN (SELECT Id FROM deleted);
END;

CREATE TRIGGER trg_three
ON Orders
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedOrdersLog (OrderId, CustomerId, CarId, OrderDate, DeletedAt)
    SELECT Id, CustomerId, CarId, OrderDate, GETDATE()
    FROM deleted;
END;

CREATE TRIGGER trg_four
ON Cars
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Year)
    BEGIN
        UPDATE Cars
        SET Price = Price * 0.95
        FROM Cars c
        JOIN inserted i ON c.Id = i.Id;
    END
END;

CREATE TRIGGER trg_five
ON Orders
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Orders o ON i.CustomerId = o.CustomerId AND i.CarId = o.CarId
    )
    BEGIN
        RAISERROR ('nuhuh', 16, 1);
        RETURN;
    END
    INSERT INTO Orders (CustomerId, CarId, OrderDate)
    SELECT CustomerId, CarId, OrderDate FROM inserted;
END;
