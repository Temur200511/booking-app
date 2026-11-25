-- Database constraint tests. Expected results are shown in each label.
INSERT INTO users (full_name, email, password_hash)
VALUES ('Test Customer', 'test@example.com', 'not-a-real-hash');

\echo '--- TEST 1: valid booking 10:00-10:30 (expect INSERT 0 1)'
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 1, 1,
        '2026-12-01 10:00+05', '2026-12-01 10:30+05', 80000);

\echo '--- TEST 2: back-to-back booking 10:30-11:00, same staff (expect INSERT 0 1)'
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 1, 1,
        '2026-12-01 10:30+05', '2026-12-01 11:00+05', 80000);

\echo '--- TEST 3: overlapping booking 10:15-10:45, same staff (expect ERROR no_double_booking)'
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 1, 1,
        '2026-12-01 10:15+05', '2026-12-01 10:45+05', 80000);

\echo '--- TEST 4: same time with a DIFFERENT staff member (expect INSERT 0 1)'
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 2, 1,
        '2026-12-01 10:15+05', '2026-12-01 10:45+05', 80000);

\echo '--- TEST 5: cancel the 10:00 booking, then rebook 10:00-10:30 (expect UPDATE 1, INSERT 0 1)'
UPDATE appointments SET status = 'cancelled'
WHERE staff_id = 1 AND start_time = '2026-12-01 10:00+05';
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 1, 1,
        '2026-12-01 10:00+05', '2026-12-01 10:30+05', 80000);

\echo '--- TEST 6: end time before start time (expect ERROR valid_time_range)'
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 3, 1,
        '2026-12-01 12:00+05', '2026-12-01 11:00+05', 80000);

\echo '--- TEST 7: invalid status value (expect ERROR appointments_status_check)'
INSERT INTO appointments (user_id, staff_id, service_id, start_time, end_time, status, price_at_booking)
VALUES ((SELECT id FROM users WHERE email='test@example.com'), 3, 1,
        '2026-12-01 13:00+05', '2026-12-01 13:30+05', 'maybe', 80000);

\echo '--- TEST 8: duplicate email (expect ERROR users_email_key)'
INSERT INTO users (full_name, email, password_hash)
VALUES ('Duplicate', 'test@example.com', 'x');

\echo '--- CLEANUP: delete the test user (appointments are removed by CASCADE)'
DELETE FROM users WHERE email = 'test@example.com';
SELECT COUNT(*) AS remaining_appointments FROM appointments;
