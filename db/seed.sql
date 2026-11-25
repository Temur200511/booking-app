-- Sample data for development and demo
INSERT INTO services (name, description, duration_minutes, price) VALUES
  ('Haircut', 'Classic haircut', 30, 80000),
  ('Beard trim', 'Beard shaping and trim', 20, 50000),
  ('Haircut + beard', 'Full grooming package', 50, 120000),
  ('Kids haircut', 'For children under 12', 25, 60000);

INSERT INTO staff (full_name, specialty) VALUES
  ('Aziz Karimov', 'Senior barber'),
  ('Dilshod Rahimov', 'Barber'),
  ('Nodira Yusupova', 'Stylist');

-- Which staff member can perform which service
INSERT INTO staff_services (staff_id, service_id) VALUES
  (1, 1), (1, 2), (1, 3),
  (2, 1), (2, 2),
  (3, 1), (3, 4);
