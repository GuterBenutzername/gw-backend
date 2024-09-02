insert into
    api.users (name)
values
    ('aycii'),
    ('tyler'),
    ('scorby'),
    ('chet');

insert into
    api.courses (name, user_id)
values
    ('Physics H', (select id from api.users where name = 'aycii')),
    ('ADHD III AP', (select id from api.users where name = 'tyler')),
    ('Conduction II', (select id from api.users where name = 'scorby')),
    ('Band', (select id from api.users where name = 'chet'));

insert into
    api.assignments (name, grade, weight, weight_complex, t, course_id)
values
    ('PP.5', 100, 0.15, null, false, (select id from api.courses where name = 'Physics H')),
    ('pp4', 100, 0.15, null, false, (select id from api.courses where name = 'Physics H')),
    ('hquiz', 90, 0.25, null,false, (select id from api.courses where name = 'Physics H')),
    ('pp3', 100, 0.15, null, false, (select id from api.courses where name = 'Physics H')),
    ('safe', 100, 0.25, 0.1, false, (select id from api.courses where name = 'Physics H'));

insert into
    api.assignments (name, grade, weight, t, course_id)
values
    ('easy homework', 0, 0.15, false, (select id from api.courses where name = 'ADHD III AP')),
    ('hard quiz', 30, 0.25, false, (select id from api.courses where name = 'ADHD III AP')),
    ('future test', 95, 0.65, true, (select id from api.courses where name = 'ADHD III AP')),

    ('easy homework', 100, 0.15, false, (select id from api.courses where name = 'Conduction II')),
    ('hard quiz', 100, 0.25, false, (select id from api.courses where name = 'Conduction II')),
    ('future test', 105, 0.65, false, (select id from api.courses where name = 'Conduction II')),
    
    ('easy homework', 90, 0.15, false, (select id from api.courses where name = 'Band')),
    ('hard quiz', 90, 0.25, false, (select id from api.courses where name = 'Band')),
    ('future test', 60, 0.65, true, (select id from api.courses where name = 'Band'));
