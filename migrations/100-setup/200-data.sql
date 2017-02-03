

    set search_path to "row_restriction_service";


    insert into "principalType" ("identifier") values ('role');


    insert into "action" ("identifier") values ('create');
    insert into "action" ("identifier") values ('update');
    insert into "action" ("identifier") values ('read');
    insert into "action" ("identifier") values ('delete');



    insert into "valueType" ("identifier", "description") values ('constant', 'the column must be compared to a constant value');
    insert into "valueType" ("identifier", "description") values ('function', 'the column must be compared to the result fo a function');
    insert into "valueType" ("identifier", "description") values ('variable', 'the column must be compared to a variable');



    insert into "comparator" ("identifier", "description") values ('equal', 'the value in the column must equal to');
    insert into "comparator" ("identifier", "description") values ('notEqual', 'the value in the column must not equal to');
    insert into "comparator" ("identifier", "description") values ('in', 'the value in the column must be one of');
    insert into "comparator" ("identifier", "description") values ('notIn', 'the value in the column must be not on of');
    insert into "comparator" ("identifier", "description") values ('gt', 'the value in the column must be greather than');
    insert into "comparator" ("identifier", "description") values ('lt', 'the value in the column must be less than');
    insert into "comparator" ("identifier", "description") values ('gte', 'the value in the column must be greather than or equal to');
    insert into "comparator" ("identifier", "description") values ('lte', 'the value in the column must be less than or equal to');

