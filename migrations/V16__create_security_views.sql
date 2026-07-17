CREATE SCHEMA IF NOT EXISTS reporting;

CREATE VIEW reporting.patient_directory AS
SELECT id AS patient_id,
       patient_number,
       first_name,
       last_name,
       date_of_birth,
       gender,
       city,
       status
FROM clinical.patients;

CREATE VIEW reporting.lab_work_queue AS
SELECT lo.order_number,
       p.patient_number,
       p.first_name || ' ' || p.last_name AS patient_name,
       lt.test_code,
       lt.test_name,
       lo.priority,
       loi.status                         AS test_status,
       loi.specimen_collected_at,
       lo.ordered_at
FROM clinical.lab_order_items loi
         JOIN clinical.lab_orders lo
              ON loi.lab_order_id = lo.id
         JOIN clinical.lab_tests lt
              ON loi.lab_test_id = lt.id
         JOIN clinical.consultations c
              ON lo.consultation_id = c.id
         JOIN clinical.appointments a
              ON c.appointment_id = a.id
         JOIN clinical.patients p
              ON a.patient_id = p.id;

CREATE VIEW reporting.invoice_balances AS
WITH item_totals AS (SELECT invoice_id,
                            SUM(quantity * unit_price) AS invoice_total
                     FROM billing.invoice_items
                     GROUP BY invoice_id),
     payment_totals AS (SELECT invoice_id,
                               SUM(amount) AS total_paid
                        FROM billing.payments
                        WHERE status = 'COMPLETED'
                        GROUP BY invoice_id)
SELECT i.id                               AS invoice_id,
       i.invoice_number,
       p.patient_number,
       p.first_name || ' ' || p.last_name AS patient_name,
       COALESCE(it.invoice_total, 0)      AS invoice_total,
       COALESCE(pt.total_paid, 0)         AS total_paid,
       COALESCE(it.invoice_total, 0)
           - COALESCE(pt.total_paid, 0)   AS outstanding_balance,
       i.status                           AS invoice_status,
       i.issued_at,
       i.due_date
FROM billing.invoices i
         JOIN clinical.patients p
              ON i.patient_id = p.id
         LEFT JOIN item_totals it
                   ON i.id = it.invoice_id
         LEFT JOIN payment_totals pt
                   ON i.id = pt.invoice_id;