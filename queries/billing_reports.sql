-- Full invoice details
SELECT
    i.invoice_number,
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    ii.description,
    ii.quantity,
    ii.unit_price,
    ii.quantity * ii.unit_price AS line_total
FROM billing.invoices i
         JOIN clinical.patients p
              ON i.patient_id = p.id
         JOIN billing.invoice_items ii
              ON i.id = ii.invoice_id
ORDER BY i.invoice_number, ii.id;


-- Invoice totals, payments, and balances
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
    i.invoice_number,
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,

    COALESCE(it.invoice_total, 0) AS invoice_total,
    COALESCE(pt.total_paid, 0) AS total_paid,

    COALESCE(it.invoice_total, 0)
        - COALESCE(pt.total_paid, 0) AS outstanding_balance

FROM billing.invoices i

         JOIN clinical.patients p
              ON i.patient_id = p.id

         LEFT JOIN item_totals it
                   ON i.id = it.invoice_id

         LEFT JOIN payment_totals pt
                   ON i.id = pt.invoice_id

ORDER BY i.issued_at DESC;


-- Invoices with outstanding balances
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
    i.invoice_number,

    COALESCE(it.invoice_total, 0)
        - COALESCE(pt.total_paid, 0) AS outstanding_balance

FROM billing.invoices i

         LEFT JOIN item_totals it
                   ON i.id = it.invoice_id

         LEFT JOIN payment_totals pt
                   ON i.id = pt.invoice_id

WHERE i.status = 'ISSUED'

  AND COALESCE(it.invoice_total, 0)
          - COALESCE(pt.total_paid, 0) > 0

ORDER BY outstanding_balance DESC;


-- Payment history
SELECT
    pay.payment_number,
    i.invoice_number,
    pay.amount,
    pay.payment_method,
    pay.status,
    pay.paid_at
FROM billing.payments pay
         JOIN billing.invoices i
              ON pay.invoice_id = i.id
ORDER BY pay.paid_at DESC;