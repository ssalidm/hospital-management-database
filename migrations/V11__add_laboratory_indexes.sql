CREATE INDEX idx_lab_orders_consultation_id
    ON clinical.lab_orders(consultation_id);

CREATE INDEX idx_lab_orders_doctor_id
    ON clinical.lab_orders(ordered_by_doctor_id);

CREATE INDEX idx_lab_orders_status
    ON clinical.lab_orders(status);

CREATE INDEX idx_lab_orders_ordered_at
    ON clinical.lab_orders(ordered_at);

CREATE INDEX idx_lab_order_items_order_id
    ON clinical.lab_order_items(lab_order_id);

CREATE INDEX idx_lab_order_items_test_id
    ON clinical.lab_order_items(lab_test_id);

CREATE INDEX idx_lab_order_items_status
    ON clinical.lab_order_items(status);

CREATE INDEX idx_lab_results_interpretation
    ON clinical.lab_results(interpretation);