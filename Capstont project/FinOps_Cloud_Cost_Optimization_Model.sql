
-- ============================================================
-- PROJECT: FinOps Cloud Cost Optimization Model
-- FILE: FinOps_Sample_Data_Inserts.sql
-- PURPOSE: Insert sample records into all 12 tables
-- USERS: Ashwin T, Murildharan, Ajith, Aryasudhan
-- ============================================================
USE FinOps_Cloud_Cost_Optimization_Model;

-- ============================================================
-- IMPORTANT: Allow NULL for unresolved recommendations.
-- A recommendation will have no resolved date until completed.
-- ============================================================
ALTER TABLE recommendation
MODIFY resolved_at DATE NULL;

-- ============================================================
-- 1. APPLICATION_USER
--
-- PURPOSE:
-- Stores all users who can log in to the application.
--
-- REFERENCES:
-- No foreign key dependency.

-- USERS:
-- Ashwin T       -> FinOps Analyst
-- Murildharan    -> Team Owner
-- Ajith          -> Team Owner
-- Aryasudhan     -> Team Owner
-- ============================================================
INSERT INTO application_user
(user_id, user_name, email, password, role)
VALUES
(1, 'Ashwin T', 'ashwin@company.com', 'sample_hash_1', 'FinOps Analyst'),
(2, 'Murildharan', 'murildharan@company.com', 'sample_hash_2', 'Team Owner'),
(3, 'Ajith', 'ajith@company.com', 'sample_hash_3', 'Team Owner'),
(4, 'Aryasudhan', 'aryasudhan@company.com', 'sample_hash_4', 'Team Owner');

-- ============================================================
-- 2. CLOUD_ACCOUNT
--
-- PURPOSE:
-- Stores cloud accounts registered by the company.
--
-- REFERENCES:
-- No foreign key dependency.
--
-- EXAMPLES:
-- AWS and Azure cloud accounts.
-- ============================================================
INSERT INTO cloud_account
(account_id, provider, account_name)
VALUES
(1, 'AWS', 'Company AWS Production Account'),
(2, 'Azure', 'Company Azure Development Account');

-- ============================================================
-- 3. TEAM
--
-- PURPOSE:
-- Stores the different teams in the company.
--
-- REFERENCES:
-- owner_user_id -> application_user.user_id
--
-- EXPLANATION:
-- Each team has one owner.
-- One user can own multiple teams.
-- ============================================================
INSERT INTO team
(team_id, team_name, owner_user_id)
VALUES
(1, 'Development Team', 2),
(2, 'Testing Team', 3),
(3, 'Data Team', 4);

-- ============================================================
-- 4. CLOUD_RESOURCE
--
-- PURPOSE:
-- Stores cloud resources such as servers and databases.
--
-- REFERENCES:
-- account_id -> cloud_account.account_id
--
-- EXPLANATION:
-- Each cloud resource belongs to one cloud account.
-- One cloud account can contain multiple resources.
-- ============================================================
INSERT INTO cloud_resource
(resource_id, resource_uid, resource_name,
 resource_type, region, status, account_id)
VALUES
(1, 'i-aws-1001', 'Development Server',
 'EC2', 'ap-south-1', 'RUNNING', 1),

(2, 'i-aws-1002', 'Testing Server',
 'EC2', 'ap-south-1', 'RUNNING', 1),

(3, 'db-aws-1003', 'Production Database',
 'RDS', 'ap-south-1', 'RUNNING', 1),

(4, 'vm-az-1004', 'Data Processing VM',
 'Virtual Machine', 'Central India', 'RUNNING', 2);

-- ============================================================
-- 5. TAG_KEY
--
-- PURPOSE:
-- Stores tag categories.
--
-- REFERENCES:
-- No foreign key dependency.
--
-- EXAMPLES:
-- Team, Environment and Project.
-- ============================================================
INSERT INTO tag_key
(tag_key_id, key_name)
VALUES
(1, 'Team'),
(2, 'Environment'),
(3, 'Project');


-- ============================================================
-- 6. TAG_VALUE
--
-- PURPOSE:
-- Stores the actual values under each tag category.
--
-- REFERENCES:
-- tag_key_id -> tag_key.tag_key_id
--
-- EXAMPLE:
-- Team        -> Development Team
-- Environment -> Production
-- Project     -> FinOps Project
-- ============================================================
INSERT INTO tag_value
(tag_value_id, value_name, tag_key_id)
VALUES
(1, 'Development Team', 1),
(2, 'Testing Team', 1),
(3, 'Data Team', 1),

(4, 'Production', 2),
(5, 'Testing', 2),
(6, 'Development', 2),

(7, 'FinOps Project', 3),
(8, 'Internal Project', 3);

-- ============================================================
-- 7. RESOURCE_TAG
--
-- PURPOSE:
-- Connects cloud resources with their assigned tag values.
--
-- REFERENCES:
-- resource_id  -> cloud_resource.resource_id
-- tag_value_id -> tag_value.tag_value_id
--
-- EXAMPLE:
-- Development Server -> Development Team
-- Development Server -> Development
-- Development Server -> FinOps Project
--
-- One resource can have multiple tags.
-- ============================================================
INSERT INTO resource_tag
(resource_tag_id, resource_id, tag_value_id)
VALUES

-- Development Server (Resource ID 1)
(1, 1, 1),
(2, 1, 6),
(3, 1, 7),

-- Testing Server (Resource ID 2)
(4, 2, 2),
(5, 2, 5),
(6, 2, 8),

-- Production Database (Resource ID 3)
(7, 3, 3),
(8, 3, 4),
(9, 3, 7),

-- Data Processing VM (Resource ID 4)
(10, 4, 3),
(11, 4, 6),
(12, 4, 8);


-- ============================================================
-- 8. TEAM_TAG_MAPPING
--
-- PURPOSE:
-- Connects a team's Team tag value to its team record.
--
-- REFERENCES:
-- team_id     -> team.team_id
-- tag_value_id -> tag_value.tag_value_id
--
-- EXAMPLE:
-- Development Team tag -> Development Team record
-- ============================================================
INSERT INTO team_tag_mapping
(mapping_id, team_id, tag_value_id)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);


-- ============================================================
-- 9. DAILY_RESOURCE_COST
--
-- PURPOSE:
-- Stores daily cloud spending and average utilisation.
--
-- REFERENCES:
-- resource_id -> cloud_resource.resource_id
--
-- EXPLANATION:
-- daily_cost       -> Amount spent on that date.
-- avg_utilization  -> Average percentage of resource used.
-- cost_date        -> Date on which the cost occurred.
--
-- Example:
-- Testing Server costs Rs. 700 with 15% utilisation.
-- ============================================================
INSERT INTO daily_resource_cost
(cost_id, cost_date, daily_cost, avg_utilization, resource_id)
VALUES

-- Development Server
(1, '2026-11-23', 500.00, 75.00, 1),
(2, '2026-11-24', 520.00, 70.00, 1),

-- Testing Server
(3, '2026-11-23', 700.00, 15.00, 2),
(4, '2026-11-24', 710.00, 12.00, 2),

-- Production Database
(5, '2026-11-23', 1200.00, 85.00, 3),
(6, '2026-11-24', 1250.00, 90.00, 3),

-- Data Processing VM
(7, '2026-11-23', 400.00, 25.00, 4),
(8, '2026-11-24', 420.00, 20.00, 4);


-- ============================================================
-- 10. TEAM_BUDGET
--
-- PURPOSE:
-- Stores the budget allocated to each team.
--
-- REFERENCES:
-- team_id -> team.team_id
--
-- EXPLANATION:
-- Each team can have budgets for different periods.
-- budget_amount represents the allowed spending limit.
-- ============================================================
INSERT INTO team_budget
(budget_id, start_date, end_date, budget_amount, team_id)
VALUES
(1, '2026-11-01', '2026-11-30', 30000.00, 1),
(2, '2026-11-01', '2026-11-30', 15000.00, 2),
(3, '2026-11-01', '2026-11-30', 20000.00, 3);


-- ============================================================
-- 11. BUDGET_ALERT
--
-- PURPOSE:
-- Stores alerts when team spending crosses a budget threshold.
--
-- REFERENCES:
-- budget_id -> team_budget.budget_id
--
-- EXPLANATION:
-- threshold_percentage -> Percentage at which alert is raised.
-- actual_spend         -> Spending when alert was generated.
-- alert_status         -> NEW / ACKNOWLEDGED / RESOLVED.
-- ============================================================
INSERT INTO budget_alert
(alert_id, threshold_percentage, actual_spend,
 alert_message, alert_status, created_at, budget_id)
VALUES

(1, 50.00, 16000.00,
 'Development Team has crossed 50 percent of its budget',
 'NEW', '2026-11-24', 1),

(2, 80.00, 25000.00,
 'Development Team has crossed 80 percent of its budget',
 'ACKNOWLEDGED', '2026-11-25', 1),

(3, 50.00, 8000.00,
 'Testing Team has crossed 50 percent of its budget',
 'NEW', '2026-11-24', 2),

(4, 50.00, 11000.00,
 'Data Team has crossed 50 percent of its budget',
 'RESOLVED', '2026-11-25', 3);


-- ============================================================
-- 12. RECOMMENDATION
--
-- PURPOSE:
-- Stores suggestions to reduce cloud spending.
--
-- REFERENCES:
-- resource_id -> cloud_resource.resource_id
--
-- EXPLANATION:
-- recommendation_type -> Type of cost-saving suggestion.
-- estimated_monthly_savings -> Expected monthly savings.
-- status -> PENDING / IN_PROGRESS / COMPLETED / REJECTED.
-- resolved_at -> Date when recommendation was completed.
--
-- NULL resolved_at means it is not yet resolved.
-- ============================================================
INSERT INTO recommendation
(recommendation_id, recommendation_type, description,
 estimated_monthly_savings, status, created_at,
 resolved_at, resource_id)
VALUES

(1, 'DOWNSIZE',
 'Consider reducing the testing server size due to low utilisation',
 3000.00, 'PENDING', '2026-11-24', NULL, 2),

(2, 'STOP_IDLE',
 'Stop the development server during non-working hours',
 2000.00, 'IN_PROGRESS', '2026-11-24', NULL, 1),

(3, 'STORAGE_OPTIMIZATION',
 'Move infrequently accessed database backups to cheaper storage',
 1500.00, 'COMPLETED', '2026-11-20', '2026-11-25', 3),

(4, 'DOWNSIZE',
 'Review the data processing VM size to reduce cloud spending',
 2500.00, 'PENDING', '2026-11-25', NULL, 4);


-- ============================================================
-- END OF SAMPLE DATA INSERTION
-- ============================================================


-- ============================================================
-- VERIFICATION
-- Run these queries to check the inserted records.
-- ============================================================

SELECT * FROM application_user;

SELECT * FROM cloud_account;

SELECT * FROM team;

SELECT * FROM cloud_resource;

SELECT * FROM tag_key;

SELECT * FROM tag_value;

SELECT * FROM resource_tag;

SELECT * FROM team_tag_mapping;

SELECT * FROM daily_resource_cost;

SELECT * FROM team_budget;

SELECT * FROM budget_alert;

SELECT * FROM recommendation;


-- ============================================================
-- END OF SCRIPT
-- ============================================================
