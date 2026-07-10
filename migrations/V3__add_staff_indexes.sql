CREATE INDEX idx_staff_members_department_id
    ON clinical.staff_members(department_id);

CREATE INDEX idx_staff_members_role
    ON clinical.staff_members(role);

CREATE INDEX idx_staff_members_employment_status
    ON clinical.staff_members(employment_status);