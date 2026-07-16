CREATE INDEX idx_invoices_patient_id
    ON billing.invoices(patient_id);

CREATE INDEX idx_invoices_consultation_id
    ON billing.invoices(consultation_id);

CREATE INDEX idx_invoices_admission_id
    ON billing.invoices(admission_id);

CREATE INDEX idx_invoices_status
    ON billing.invoices(status);

CREATE INDEX idx_invoices_issued_at
    ON billing.invoices(issued_at);

CREATE INDEX idx_invoice_items_invoice_id
    ON billing.invoice_items(invoice_id);

CREATE INDEX idx_invoice_items_service_id
    ON billing.invoice_items(service_id);

CREATE INDEX idx_payments_invoice_id
    ON billing.payments(invoice_id);

CREATE INDEX idx_payments_status
    ON billing.payments(status);

CREATE INDEX idx_payments_paid_at
    ON billing.payments(paid_at);