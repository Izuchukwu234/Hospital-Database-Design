# Hospital-Database-Design-Using-SQL

### Introduction
TheHospitalDB is a comprehensive database management system designed to streamline and enhance the operations of a hospital. This project includes the creation of a relational database with various tables, stored procedures, views, triggers, and security measures to handle the complex data requirements of a hospital.

### Database Structure
The database consists of the following key components:

### Tables
###### Patients
Stores patient details such as names, addresses, date of birth, gender, insurance, contact information, and date of discharge.

###### Doctors
Stores doctor details including names, specialties, and associated department IDs.

###### Appointments
Manages appointment details linking patients, doctors, and departments along with appointment dates, times, and status.

###### PastAppointments
Records details of past appointments, similar to the Appointments table.

###### MedicalRecords
Maintains medical records for patients, including diagnosis, prescribed medicines, allergies, and past appointment notes.

###### Departments
Contains information about various hospital departments.

###### Reviews
Stores reviews and feedback from patients about doctors.

###### Auth_Password
Handles authentication with hashed passwords for secure login.

###### Schemas
The database is organized into schemas to enhance performance and security:

Patient: Contains tables related to patient information: Patients, MedicalRecords, and Appointments.
Doctors: Includes Doctors and Departments tables.

###### Authentication
Contains the Auth_Password table for handling login details.

###### Stored Procedures and Functions
addWithHashedPassword
Adds users with hashed passwords for security.

uspNewPatient
Inserts new patient records with transaction management.

update_doc_details
Updates doctor details.

fetch_diagnosis_alergies_today
Retrieves diagnosis and allergies for patients with appointments today.

remove_completed_app
Deletes completed appointments and related medical records.

###### Views
appointment_view
Provides a consolidated view of all appointments (past and current), doctor details, department information, and patient reviews.

###### Triggers
update_app_status
Automatically updates appointment status to 'Available' when an appointment is canceled.

###### Security
Users and roles are created to manage database access.
chief_admin: Manages the Patient and Authentication schemas.
chief_doctor: Manages the Doctors schema.
Privileges are granted and revoked to ensure secure access.
Database Queries

### How to Use

###### Creating the Database
-Run the SQL script to create the database, tables, and insert initial data.
Managing Data.
-Use the stored procedures and functions provided to manage patient records, appointments, and other data efficiently.
Security.
-Ensure the security measures are implemented to protect sensitive patient information.

###### Backup and Recovery
Regularly back up the database to prevent data loss and ensure quick recovery in case of failures.

###### Conclusion
TheHospitalDB project provides a robust database management system for hospitals, focusing on efficient data handling, security, and comprehensive functionality to meet the needs of modern healthcare facilities. This README serves as a guide to understanding and utilizing the various features and components of the database system.
