

    set search_path to "row_restriction_service";







    create table "principalType" (
          "id"                          serial not null
        , "identifier"                  varchar(50) not null
        , constraint "principalType_pk"
            primary key ("id")
        , constraint "principalType_unique_identifier"
            unique ("identifier")
    );

    create table "principal" (
          "id"                          serial not null
        , "id_principalType"            int not null
        , "principalId"                 int not null
        , constraint "principal_pk"
            primary key ("id")
        , constraint "principal_unique_principal"
            unique ("id_principalType", "principalId")
        , constraint "principal_fk_principalType"
            foreign key ("id_principalType")
            references "principalType"("id")
            on update cascade
            on delete restrict
    );






    create table "service" (
          "id"                          serial not null
        , "identifier"                  varchar(50) not null
        , constraint "service_pk"
            primary key ("id")
        , constraint "service_unique_identifier"
            unique ("identifier")
    );

    create table "resource" (
          "id"                          serial not null
        , "identifier"                  varchar(50) not null
        , "created"                     timestamp without time zone not null default now()
        , "updated"                     timestamp without time zone not null default now()
        , "deleted"                     timestamp without time zone
        , constraint "resource_pk"
            primary key ("id")
        , constraint "resource_unique_identifier"
            unique ("identifier")
    );





    create table "action" (
          "id"                          serial not null
        , "identifier"                  varchar(50) not null
        , "created"                     timestamp without time zone not null default now()
        , "updated"                     timestamp without time zone not null default now()
        , "deleted"                     timestamp without time zone
        , constraint "action_pk"
            primary key ("id")
        , constraint "action_unique_identifier"
            unique ("identifier")
    );







    create table "comparator" (
          "id"                          serial not null
        , "identifier"                  varchar(50) not null
        , "description"                 text
        , "created"                     timestamp without time zone not null default now()
        , "updated"                     timestamp without time zone not null default now()
        , "deleted"                     timestamp without time zone
        , constraint "comparator_pk"
            primary key ("id")
        , constraint "comparator_unique_identifier"
            unique ("identifier")
    );

    create table "valueType" (
          "id"                          serial not null
        , "identifier"                  varchar(50) not null
        , "description"                 text
        , "created"                     timestamp without time zone not null default now()
        , "updated"                     timestamp without time zone not null default now()
        , "deleted"                     timestamp without time zone
        , constraint "valueType_pk"
            primary key ("id")
        , constraint "valueType_unique_identifier"
            unique ("identifier")
    );

    create table "rowRestriction" (
          "id"                          serial not null
        , "id_valueType"                int not null
        , "id_comparator"               int not null
        , "id_service"                  int not null
        , "property"                    varchar(200) not null
        , "value"                       json not null
        , "nullable"                    boolean not null default false
        , "global"                      boolean not null default false
        , "identifier"                  varchar(200) not null
        , "description"                 text
        , "created"                     timestamp without time zone not null default now()
        , "updated"                     timestamp without time zone not null default now()
        , "deleted"                     timestamp without time zone
        , constraint "rowRestriction_pk"
            primary key ("id")
        , constraint "rowRestriction_unique_identifier"
            unique ("identifier", "id_service")
        , constraint "rowRestriction_fk_valueType"
            foreign key ("id_valueType")
            references "valueType"("id")
            on update cascade
            on delete restrict
        , constraint "rowRestriction_fk_comparator"
            foreign key ("id_comparator")
            references "comparator"("id")
            on update cascade
            on delete restrict
        , constraint "rowRestriction_fk_service"
            foreign key ("id_service")
            references "service"("id")
            on update cascade
            on delete restrict
    );

    create table "rowRestriction_resource" (
          "id_rowRestriction"           int not null
        , "id_resource"                 int not null
        , constraint "rowRestriction_resource_pk"
            primary key ("id_rowRestriction", "id_resource")
        , constraint "rowRestriction_resource_fk_rowRestriction"
            foreign key ("id_rowRestriction")
            references "rowRestriction"("id")
            on update cascade
            on delete restrict
        , constraint "rowRestriction_resource_fk_resource"
            foreign key ("id_resource")
            references "resource"("id")
            on update cascade
            on delete restrict
    );

    create table "rowRestriction_action" (
          "id_rowRestriction"           int not null
        , "id_action"                   int not null
        , constraint "rowRestriction_action_pk"
            primary key ("id_rowRestriction", "id_action")
        , constraint "rowRestriction_action_fk_rowRestriction"
            foreign key ("id_rowRestriction")
            references "rowRestriction"("id")
            on update cascade
            on delete restrict
        , constraint "rowRestriction_action_fk_action"
            foreign key ("id_action")
            references "action"("id")
            on update cascade
            on delete restrict
    );





    create table "principal_rowRestriction" (
          "id_rowRestriction"           int not null
        , "id_principal"                int not null
        , constraint "principal_rowRestrictionpk"
            primary key ("id_rowRestriction", "id_principal")
        , constraint "principal_rowRestriction_fk_rowRestriction"
            foreign key ("id_rowRestriction")
            references "rowRestriction"("id")
            on update cascade
            on delete restrict
        , constraint "principal_rowRestriction_fk_principal"
            foreign key ("id_principal")
            references "principal"("id")
            on update cascade
            on delete restrict
    );