-- Full laboratory results report
SELECT
    lo.order_number,
    p.patient_number,
    p.first_name || ' ' || p.last_name AS patient_name,
    lt.test_name,
    lr.result_value,
    lr.result_unit,
    lr.reference_range_used,
    lr.interpretation,
    lr.result_status
FROM clinical.lab_results lr
         JOIN clinical.lab_order_items loi
              ON lr.lab_order_item_id = loi.id
         JOIN clinical.lab_orders lo
              ON loi.lab_order_id = lo.id
         JOIN clinical.lab_tests lt
              ON loi.lab_test_id = lt.id
         JOIN clinical.consultations c
              ON lo.consultation_id = c.id
         JOIN clinical.appointments a
              ON c.appointment_id = a.id
         JOIN clinical.patients p
              ON a.patient_id = p.id
ORDER BY lo.ordered_at DESC, lt.test_name;

-- Laboratory tests still waiting for results
SELECT
    lo.order_number,
    lt.test_name,
    loi.status
FROM clinical.lab_order_items loi
         JOIN clinical.lab_orders lo
              ON loi.lab_order_id = lo.id
         JOIN clinical.lab_tests lt
              ON loi.lab_test_id = lt.id
         LEFT JOIN clinical.lab_results lr
                   ON lr.lab_order_item_id = loi.id
WHERE lr.id IS NULL
  AND loi.status <> 'CANCELLED'
ORDER BY lo.ordered_at;

-- Count how many times each test was ordered
SELECT
    lt.test_name,
    COUNT(loi.id) AS times_ordered
FROM clinical.lab_order_items loi
         JOIN clinical.lab_tests lt
              ON loi.lab_test_id = lt.id
GROUP BY lt.test_name
ORDER BY times_ordered DESC;

-- Abnormal laboratory results
SELECT
    lo.order_number,
    lt.test_name,
    lr.result_value,
    lr.result_unit,
    lr.interpretation
FROM clinical.lab_results lr
         JOIN clinical.lab_order_items loi
              ON lr.lab_order_item_id = loi.id
         JOIN clinical.lab_orders lo
              ON loi.lab_order_id = lo.id
         JOIN clinical.lab_tests lt
              ON loi.lab_test_id = lt.id
WHERE lr.interpretation IN ('HIGH', 'LOW', 'ABNORMAL')
ORDER BY lr.recorded_at DESC;