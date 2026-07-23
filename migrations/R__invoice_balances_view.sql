CREATE OR REPLACE VIEW reporting.invoice_balances AS
WITH item_totals AS (
    SELECT
        invoice_id,
        SUM(quantity * unit_price) AS invoice_total
    FROM billing.invoice_items
    GROUP BY invoice_id
),
     payment_totals AS (
         SELECT
             invoice_id,
             SUM(amount) AS total_paid
         FROM billing.payments
         WHERE status = 'COMPLETED'
         GROUP BY invoice_id
     )
SELECT
    i.id AS invoice_id,
    i.invoice_number,
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,

    COALESCE(it.invoice_total, 0) AS invoice_total,
    COALESCE(pt.total_paid, 0) AS total_paid,

    COALESCE(it.invoice_total, 0)
        - COALESCE(pt.total_paid, 0) AS outstanding_balance,

    -- Preserve the existing column positions.
    i.status AS invoice_status,
    i.issued_at,
    i.due_date,

    -- New columns must be added at the end.
    CASE
        WHEN i.status = 'CANCELLED'
            THEN 'CANCELLED'

        WHEN COALESCE(pt.total_paid, 0) = 0
            THEN 'UNPAID'

        WHEN COALESCE(pt.total_paid, 0)
            < COALESCE(it.invoice_total, 0)
            THEN 'PARTIALLY_PAID'

        ELSE 'PAID'
        END AS payment_status

FROM billing.invoices i

         JOIN clinical.patients p
              ON i.patient_id = p.id

         LEFT JOIN item_totals it
                   ON i.id = it.invoice_id

         LEFT JOIN payment_totals pt
                   ON i.id = pt.invoice_id;