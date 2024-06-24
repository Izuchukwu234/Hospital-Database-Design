--Part 1
--Creating the database
CREATE DATABASE TheHospitalDB;

USE TheHospitalDB;
GO

-- Creating the Patient table
CREATE TABLE Patients (
    Patient_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(25) NOT NULL CHECK (FirstName = UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName) - 1))),
	LastName NVARCHAR(25) NOT NULL CHECK (LastName = UPPER(LEFT(LastName, 1)) + LOWER(SUBSTRING(LastName, 2, LEN(LastName) - 1))),
    CurrentAddress NVARCHAR(150) NOT NULL,
    DateOfBirth DATE NOT NULL,
	Gender NVARCHAR (25) NULL,
    Insurance NVARCHAR(25) NOT NULL,
    EmailAddress NVARCHAR(50) NULL CHECK (EmailAddress LIKE '%_@_%._%'),
    TelephoneNumber NVARCHAR(15) NULL,
	DateLeft DATE NOT NULL
);

-- Creating Doctors table
CREATE TABLE Doctors (
    Doctor_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    FirstName NVARCHAR(25) NOT NULL CHECK (FirstName = UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName) - 1))),
	LastName NVARCHAR(25) NOT NULL CHECK (LastName = UPPER(LEFT(LastName, 1)) + LOWER(SUBSTRING(LastName, 2, LEN(LastName) - 1))),
    Specialty NVARCHAR(50) NOT NULL
);

-- Create Appointments table
CREATE TABLE Appointments (
    Appointment_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    AppointmentStatus NVARCHAR(20),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID)
);

-- Creating Past Appointments table
CREATE TABLE PastAppointments (
    PastAppointment_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
	Department_ID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    AppointmentStatus NVARCHAR(20),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
	FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);

-- Creating Medical Records table
CREATE TABLE MedicalRecords (
    Record_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Appointment_ID INT NOT NULL,
    Diagnosis NVARCHAR(250) NOT NULL,
    MedicinesPrescribed NVARCHAR(MAX) NOT NULL,
    MedicinePrescribedDate DATE NOT NULL,
    Allergies NVARCHAR(MAX) NOT NULL,
	PastAppointments NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointments(Appointment_ID)
);

-- Creating Departments table
CREATE TABLE Departments (
    Department_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL,
    DepartmentDescription NVARCHAR(MAX) NOT NULL
);

-- Creating a Review table
CREATE TABLE Reviews (
    Review_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Review NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

-- Creating Authentication table for enhancing Database security
CREATE TABLE Auth_Password (
    UserID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Username NVARCHAR(25) UNIQUE NOT NULL,
    HashedPassword BINARY(64) NOT NULL,
	Salt UNIQUEIDENTIFIER
);

-- Altering Auth_Password table to reference Patient_ID table
ALTER TABLE Auth_Password
ADD Patient_ID INT NOT NULL,
CONSTRAINT FK_Auth_Patients FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID);

-- Altering Appointments table to include Department_ID
ALTER TABLE Appointments
ADD Department_ID INT NOT NULL,
CONSTRAINT FK_Appointment_Department FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID);

-- Altering Doctors table to include Department_ID
ALTER TABLE Doctors
ADD Department_ID INT NOT NULL,
CONSTRAINT FK_Doctor_Department FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID);

-- Part 2
-- 2. Adding a constraint to check that the appointment date is not in the past
ALTER TABLE Appointments
ADD CONSTRAINT CHK_appointment_date CHECK (AppointmentDate >= CAST(GETDATE() AS DATE));

-- Populating the tables with atleast 7 records with dummy records
-- For the Patient table
ALTER TABLE Patients
ALTER COLUMN DateLeft DATE NULL

INSERT INTO Patients (FirstName, LastName, CurrentAddress, DateOfBirth, Gender, Insurance, EmailAddress, TelephoneNumber, DateLeft)
VALUES
    ('Jude', 'Mbasor', '64 Romney Street', '1971-04-13', 'Male', 'AXA Health', 'judembasor@gmail.com', '07-421-849-113', '2024-03-24'),
    ('Christian', 'Chikwado', 'No 34 Moston Street', '1994-03-18', 'Male', 'Aviva', 'christian.chikwado@yahoo.com', '07-239-023-663', NULL),
    ('Chimuanya', 'Ibecheozor', '7 Langworthy Street', '1965-11-12', 'Male', 'The Exeter', 'chimuanya.i@gmail.com', '07-111-021-000', NULL),
    ('Debbie', 'Doncaster', '11 Church Street', '1970-11-23', 'Female', 'Vitality', 'debbie.doncaster@gmail.com', '07-231-222-414', NULL),
    ('Katrina', 'Edwards', '62 Pembrokshire Street', '1998-02-02', 'Female', 'Barclays Insurance', 'kat.edwards@ymail.com', '07-822-400-999', NULL),
    ('Nancy', 'Uchendu', '33 Anchorage Street', '1983-01-31', 'Female', 'National Friendly', 'nancy.uchendu@gmail.com', '07-121-478-300', NULL),
    ('Kingsley', 'Asogwa', '10 Cornbrook Street', '1999-12-24', 'Male', 'WPA', 'kingsley.a@gmail.com', '07-221-333-902', NULL),
	('Emmanuel', 'Okoh', '8 Pomona Street', '1967-07-18', 'Male', 'Westfield Health', 'emmanuel7674@yahoo.com', '07-982-922-200', NULL);

-- For the Departments table
INSERT INTO Departments (DepartmentName, DepartmentDescription)
VALUES
    ('Cardiology', 'Known in heart-related diseases'),
    ('Pediatrics', 'Good experience in medical care for infants, children, and adolescents'),
    ('Dermatology', 'Specializes in treating skin, hair, and nail conditions'),
    ('Orthopedics', 'Very good in musculoskeletal system disorders and injuries'),
	('Oncology', 'Specializes in cancer diagnosis and treatment'),
    ('Dentistry', 'Known in tooth diagnosis and treatment'),
    ('Internal Medicine', 'Specializes in diagnosis and treatment of the gall bladder'),
    ('Anatomy', 'Handled with care in human body system disorders and diseases');

-- For the Doctors table
INSERT INTO Doctors (FirstName, LastName, Specialty, Department_ID)
VALUES
    ('Chinedu', 'Nwankwo', 'Clinical Cardiology', 1),
    ('Claire', 'Jeremy', 'Pediatric Hematology',  2),
    ('King', 'Jamil', 'Cutaneous Allergy and Immunology', 3),
    ('James', 'Solomon', 'Podiatry', 4),
    ('Gabriel', 'Habib', 'Neurology', 5),
    ('Joshua', 'Olamide', 'Endodontics', 6),
    ('Meyek', 'Singh', 'Gastroenterologists', 7),
	('Emeka', 'Eze', 'Embryology', 8);

-- For the Appointment table
INSERT INTO Appointments (Patient_ID, Doctor_ID, Department_ID, AppointmentDate, AppointmentTime, AppointmentStatus)
VALUES
    (1, 1, 1, '2024-03-24', '12:00', 'Completed'),
    (2, 2, 2, '2024-03-29', '10:00', 'Pending'),
    (3, 3, 3, '2024-03-31', '12:00', 'Pending'),
    (4, 4, 4, '2024-03-26', '09:00', 'Pending'),
    (5, 5, 5, '2024-03-27', '14:00', 'Canceled'),
    (6, 6, 6, '2024-03-28', '12:00', 'Pending'),
    (7, 7, 7, '2024-03-24', '13:00', 'Completed'),
	 (8, 8, 8, '2024-03-30', '16:00', 'Pending');

-- Updating the tables to meet up with the questions asked in the project
UPDATE Appointments
SET AppointmentStatus = 'Cancelled'
WHERE AppointmentStatus = 'Canceled'

INSERT INTO Appointments (Patient_ID, Doctor_ID, Department_ID, AppointmentDate, AppointmentTime, AppointmentStatus)
SELECT a.Patient_ID, b.Doctor_ID, b.Department_ID, '2024-03-26', '14:00', 'Completed'
FROM Patients a
INNER JOIN Doctors b ON a.Patient_ID = b.Doctor_ID
WHERE b.Specialty = 'Gastroenterologists';

-- For the PastAppointment table
INSERT INTO PastAppointments (Patient_ID, Doctor_ID, Department_ID, AppointmentDate, AppointmentTime, AppointmentStatus)
VALUES
    (1, 1, 1, '2024-02-24', '09:00', 'Completed'),
    (2, 2, 2, '2024-01-29', '10:00', 'Completed'),
    (3, 3, 3, '2023-03-31', '11:00', 'Completed'),
    (4, 4, 4, '2023-01-26', '12:00', 'Completed'),
    (5, 5, 5, '2023-02-27', '13:00', 'Completed'),
    (6, 6, 6, '2023-02-28', '14:00', 'Completed'),
    (7, 7, 7, '2023-08-24', '15:00', 'Completed'),
	 (8, 8, 8, '2023-07-30', '17:00', 'Completed');

-- For the Medical Record table
INSERT INTO MedicalRecords (Patient_ID,  Appointment_ID, Diagnosis, MedicinesPrescribed, MedicinePrescribedDate, Allergies, PastAppointments)
VALUES
    (1, 2, 'Hypertension', 'Lisinopril', '2024-04-23', 'None', 'None'),
    (2, 3, 'Common cold', 'Rest, Plenty of fluids', '2024-04-29', 'None', 'None'),
    (3, 4, 'Eczema', 'Eczema cream', '2024-04-30', 'None', 'None'),
    (4, 5, 'Brain Cancer', 'Chemotherapy', '2024-03-26', 'None', 'None'),
    (5, 6, 'Fractured Legs', 'Casted', '2024-04-27', 'None', 'None'),
    (6, 7, 'Toothache', 'Ibuprofen', '2024-03-28', 'None', 'None'),
    (7, 8, 'Sight problem', 'Eye-drops', '2024-04-24', 'None', 'None'),
	(8, 9, 'Breast Cancer', 'Anti-inflammatory drugs', '2024-05-30', 'None', 'None');

-- Updating the tables to meet up with the questions asked in the project
UPDATE MedicalRecords
SET Diagnosis = 'Skin irritation',
    MedicinesPrescribed = 'Eczema cream or good skin cream'
WHERE Diagnosis = 'Hypertension' AND MedicinesPrescribed = 'Lisinopril';

-- For the Review table
INSERT INTO Reviews (Patient_ID, Review)
VALUES
    (1, 'Great experience with Doctor Chinedu. Very knowledgeable and helpful.'),
    (2, 'Dr. Claire was not very engaging so I do not recommend her'),
    (3, 'Dr. Jamil provided effective treatment for my skin condition.'),
    (4, 'Dr. Solomon accent is difficult to understand.'),
	(5, 'Dr. Gabriel was very professional and fixed my wrist problem quickly.'),
	(6, 'Dr. Joshua came late to the appointment and I hate it.'),
	(7, 'Dr. Meyek helped me to my recovery process.'),
	(8, 'Dr. Emeka explained my condition in a simple term and advised me accordingly.');

-- DATABASE SECURITY USING HASHING Procedure
CREATE PROCEDURE addWithHashedPassword
    @username NVARCHAR(25),
    @password NVARCHAR(255),
    @patientID INT
AS
BEGIN
    -- Checking if the patient exists
    IF EXISTS (SELECT 1 FROM Patients WHERE Patient_ID = @patientID)
    BEGIN
        DECLARE @salt BINARY(16) = NEWID();
        DECLARE @hashedPassword VARBINARY(64);

        -- Then Hashing the password with SHA2_512 algorithm and salt
        SET @hashedPassword = HASHBYTES('SHA2_512', @password + CAST(@salt AS NVARCHAR(36)));

        INSERT INTO Auth_Password (Username, HashedPassword, Salt, Patient_ID)
        VALUES (@username, @hashedPassword, @salt, @patientID);
    END
    ELSE
    BEGIN
        PRINT 'Does not exist.';
    END
END;

-- Executing the stored procedure for each user in the Patients table
EXEC addWithHashedPassword @username = 'judembasor', @password = 'jude224', @patientID = 1;
EXEC addWithHashedPassword @username = 'christianchikwado_', @password = '217chris', @patientID = 2;
EXEC addWithHashedPassword @username = 'cibecheozor', @password = 'ibe419', @patientID = 3;
EXEC addWithHashedPassword @username = 'debbie666', @password = 'dondebbie', @patientID = 4;
EXEC addWithHashedPassword @username = 'kateddie', @password = 'kat900', @patientID = 5;
EXEC addWithHashedPassword @username = 'nancy707', @password = 'nancy232', @patientID = 6;
EXEC addWithHashedPassword @username = 'kingzy', @password = 'kingman757', @patientID = 7;
EXEC addWithHashedPassword @username = 'emmytex', @password = 'emmy448', @patientID = 8;

SELECT * FROM Auth_Password

-- A user-defined function for calculating age
CREATE FUNCTION dbo.get_age (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());
    RETURN @Age;
END;
GO

-- 3. List all the patients with older than 40 and have Cancer in diagnosis.
SELECT 
    b.FirstName AS [First Name], 
    b.LastName AS [Last Name],
    dbo.get_age(b.DateOfBirth) AS Age,
    MAX(a.Diagnosis) AS Diagnosis
FROM Patients b
INNER JOIN MedicalRecords a 
ON b.Patient_ID = a.Patient_ID
WHERE dbo.get_age(b.DateOfBirth) > 40 AND a.Diagnosis LIKE '%cancer%'
GROUP BY b.FirstName, b.LastName, dbo.get_age(b.DateOfBirth);

-- 4.a Searching the database of the hospital for matching character strings by name of medicine.
-- Created a user-defined function for searching medicine and sorted results with most recent medicine prescribed date first
CREATE FUNCTION search_med
(
    @med_name NVARCHAR(150)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 100 PERCENT
        Patient_ID, Diagnosis, MedicinesPrescribed AS [Medicine Prescribed], MedicinePrescribedDate AS [Prescribed Date]
    FROM MedicalRecords
    WHERE MedicinesPrescribed LIKE '%' + @med_name + '%'
    ORDER BY MedicinePrescribedDate DESC
);

-- Calling the function
SELECT * FROM search_med('ecz');


-- 4.b Returning a full list of diagnosis and allergies for a specific patient who has an appointment today (i.e., the system date when the query is run)
-- Created a procedure for patient who has an appointment today
CREATE PROCEDURE fetch_diagnosis_alergies_today
    @PatientID INT
AS
BEGIN
    SELECT a.FirstName, a.LastName, b.Diagnosis, b.Allergies, c.AppointmentDate, c.AppointmentTime
    FROM MedicalRecords AS b
    INNER JOIN Appointments AS c ON b.Appointment_ID = c.Appointment_ID
    INNER JOIN Patients AS a ON b.Patient_ID = a.Patient_ID
    WHERE b.Patient_ID = @PatientID AND c.AppointmentDate = CAST(GETDATE() AS DATE);
END;

EXEC fetch_diagnosis_alergies_today @PatientID = 4;


-- 4.c Updating the details for an existing doctor
-- Created a procedure to update doctors details
CREATE PROCEDURE update_doc_details
    @DoctorID INT,
    @updated_fname NVARCHAR(50),
    @updated_lname NVARCHAR(50),
    @updated_specialty NVARCHAR(75)
AS
BEGIN
    UPDATE Doctors
    SET FirstName = @updated_fname,
        LastName = @updated_lname,
        Specialty = @updated_specialty
    WHERE Doctor_ID = @DoctorID;
END;

-- Executing the stored procedure by updating Dr Emeka's last name and specialty to Kelvin and Neurosurgeon respectively
EXEC update_doc_details @DoctorID = 8, 
											@updated_fname = 'Emeka', 
											@updated_lname = 'Kelvin', 
											@updated_specialty = 'Neuro-Surgeon';

SELECT FirstName, LastName, Specialty FROM Doctors WHERE Doctor_ID = 8


-- 4.d Deleting the appointment who status is already completed
-- Created a stored procedure

CREATE PROCEDURE remove_completed_app
AS
BEGIN
    DELETE FROM MedicalRecords WHERE Appointment_ID IN 
																										(SELECT Appointment_ID FROM Appointments 
																										WHERE AppointmentStatus = 'Completed');
    DELETE FROM Appointments WHERE AppointmentStatus = 'Completed';
END;

EXEC remove_completed_app

SELECT * FROM Appointments

-- 5. A view containing all previousand current appointments for all doctors, and including details of the 
-- department(the doctor is associated with), doctor’s specialty and any associate review/feedbackgiven for a doctor.
CREATE VIEW appointment_view AS
SELECT 
    c.AppointmentDate,
    c.AppointmentTime,
    CONCAT(a.FirstName, ' ', a.LastName) AS [Doctor Name],
    a.Specialty AS [Doctor Specialty],
    p.DepartmentName AS Department,
    r.Review AS [Doctor Review]
FROM Appointments c
INNER JOIN Doctors a ON c.Doctor_ID = a.Doctor_ID
INNER JOIN Departments p ON a.Department_ID = p.Department_ID
LEFT JOIN Reviews r ON c.Patient_ID = r.Patient_ID
UNION
SELECT 
    f.AppointmentDate,
    f.AppointmentTime,
    CONCAT(a.FirstName, ' ', a.LastName) AS [Doctor Name],
    a.Specialty AS [Doctor Specialty],
    p.DepartmentName AS Department,
    r.Review AS [Doctor Review]
FROM PastAppointments f
INNER JOIN Doctors a ON f.Doctor_ID = a.Doctor_ID
INNER JOIN Departments p ON a.Department_ID = p.Department_ID
LEFT JOIN Reviews r ON f.Patient_ID = r.Patient_ID;

SELECT * FROM appointment_view

-- 6. Creating a trigger so that the current state of an appointment can be changed to available when it is cancelled.
CREATE TRIGGER update_app_status
ON Appointments
AFTER UPDATE
AS
BEGIN
    UPDATE Appointments
    SET AppointmentStatus = 'Available'
    WHERE AppointmentStatus = 'Cancelled'
      AND 'Cancelled' IN (SELECT AppointmentStatus FROM INSERTED);
END;

SELECT * FROM Appointments

-- 7. A select query which allows the hospital to identify the number of completed appointments with the specialty of doctors as ‘Gastroenterologists’
SELECT COUNT(*) AS [Completed Appointments on Gastroenterologists]
FROM Appointments a
INNER JOIN Doctors b ON a.Doctor_ID = b.Doctor_ID
WHERE b.Specialty = 'Gastroenterologists' AND a.AppointmentStatus = 'Completed';

-- Creating SCHEMAS for improving performance and enhance Database Security
-- Creating Patients Schema and transferring patients records like Patients, Medical Records, and Appointments tables
CREATE SCHEMA Patient;
GO

ALTER SCHEMA Patient TRANSFER dbo.Patients;
ALTER SCHEMA Patient TRANSFER dbo.MedicalRecords;
ALTER SCHEMA Patient TRANSFER dbo.Appointments;

-- Verifying our schema
SELECT * FROM Patient.Patients

-- Creating Doctors Schema and transferring doctors records like Doctors and Departments tables
CREATE SCHEMA Doctors;
GO

ALTER SCHEMA Doctors TRANSFER dbo.Doctors;
ALTER SCHEMA Doctors TRANSFER dbo.Departments;

-- Verifying the schema
SELECT * FROM Doctors.Doctors



-- Creating Authentication Schema and transfer delicate login details
CREATE SCHEMA Authentication;
GO

ALTER SCHEMA Authentication TRANSFER dbo.Auth_Password

-- Verifying the schema
SELECT * FROM Authentication.Auth_Password

-- Creating users, roles and granting and revoking privileges for our schemas in the database
CREATE LOGIN WISDOMADIKE WITH PASSWORD = 'Lilwizzy222135.';
CREATE LOGIN LOVEGOD WITH PASSWORD = 'Lavida666?';

-- Creating database users for the logins created
USE TheHospitalDB;
CREATE USER WISDOMADIKE FOR LOGIN WISDOMADIKE;
CREATE USER LOVEGOD FOR LOGIN LOVEGOD;
GO

-- Creating chief_admin role which will handle the patients and authentication schemas
-- Creating chief_doctor to handle the doctors schema
CREATE ROLE chief_admin;
CREATE ROLE chief_doctor;

-- Granting privileges
-- For chief_admin role
GRANT SELECT, INSERT, DELETE, UPDATE ON SCHEMA::Patient TO chief_admin;
GRANT SELECT, INSERT, DELETE, UPDATE ON SCHEMA::Authentication TO chief_admin;

-- For chief_doctor role
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Doctors TO chief_doctor;

-- Lets assign roles to our users we created
-- Assigning Wisdom Adike as the chief_admin
ALTER ROLE chief_admin ADD MEMBER WISDOMADIKE;

-- Assigning Love God as the chief_doctor
ALTER ROLE chief_doctor ADD MEMBER LOVEGOD;

-- Lets revoke the privilege of the Love God to Delete records
REVOKE DELETE ON SCHEMA :: Doctors FROM LOVEGOD;

-- Verifying the access for Wisdom Adike
EXECUTE AS USER = 'WISDOMADIKE';
SELECT * FROM Patient.Patients;
REVERT;

-- DATABASE TRANSACTION MANAGEMENT
CREATE PROCEDURE uspNewPatient
    @FirstName nvarchar(25),
    @LastName nvarchar(25),
    @CurrentAddress nvarchar(150),
    @DateOfBirth date,
    @Gender nvarchar(25),
    @Insurance nvarchar(25),
    @EmailAddress nvarchar(50),
    @TelephoneNumber nvarchar(15),
    @DateLeft date
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Patient.Patients (FirstName, LastName, CurrentAddress, DateOfBirth, 
										Gender, Insurance, EmailAddress, TelephoneNumber, DateLeft)
        VALUES (@FirstName, @LastName, @CurrentAddress, @DateOfBirth, 
				@Gender, @Insurance, @EmailAddress, @TelephoneNumber, @DateLeft);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int;
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH;
END;


-- Executing the stored procedure with sample values
EXEC uspNewPatient
    @FirstName = 'Farida',
    @LastName = 'Okoro',
    @CurrentAddress = '42 Salford Quays, Salford',
    @DateOfBirth = '1980-02-19',
    @Gender = 'Male',
    @Insurance = 'AXA Health Insurance',
    @EmailAddress = 'farida_okoro@gmail.com',
    @TelephoneNumber = '07-222-423-11121',
    @DateLeft = NULL;

SELECT * FROM Patient.Patients
WHERE FirstName = 'Farida'

-- Setting isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


-- DATABASE BACKUP AND RECOVERY
-- Full database backup
BACKUP DATABASE TheHospitalDB
TO DISK ='C:\Users\public\TheHospitalDB-Full.bak'
WITH CHECKSUM;

-- Differential database backup
BACKUP DATABASE TheHospitalDB
TO DISK ='C:\Users\Public\TheHospitalDB_Diff.bak'
WITH DIFFERENTIAL, CHECKSUM;

-- Verifying the restore
RESTORE VERIFYONLY
FROM DISK='C:\Users\Public\TheHospitalDB-Full.bak'
WITH CHECKSUM;

RESTORE VERIFYONLY
FROM DISK='C:\Users\Public\TheHospitalDB_Diff.bak'
WITH CHECKSUM;