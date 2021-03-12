create table if not exists position_type
(
    id                   uuid DEFAULT uuid_generate_v4(),
    description          text         not null
        CONSTRAINT position_type_description_not_empty CHECK (description <> ''),
    title                varchar(255) not null
        CONSTRAINT position_type_title_not_empty CHECK (title <> ''),
    benefit_percent      bigint check ( (benefit_percent >= 0) and (benefit_percent <= 100)),
    organization_role_id uuid,
    parent_id            UUID REFERENCES position_type (id),
    CONSTRAINT position_type_pk PRIMARY key (id)
);

create table if not exists position_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT position_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES position_status_type (id),
    CONSTRAINT position_status_type_pk PRIMARY key (id)
);

create table if not exists responsibility_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT responsibility_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES responsibility_type (id),
    CONSTRAINT responsibility_type_pk PRIMARY key (id)
);

create table if not exists position
(
    id                  uuid          DEFAULT uuid_generate_v4(),
    estimated_from_date date not null default current_date,
    estimated_thru_date date,
    salary_flag         boolean,
    exempt_flag         boolean,
    full_time_flag      boolean,
    actual_from_date    date not null default current_date,
    actual_thru_date    date,
    type_id             uuid not null references position_type (id),
    status_id           uuid not null references position_status_type (id),
    within_organization uuid not null,
    budget_item_id      uuid,
    approved_thru       uuid,
    CONSTRAINT position_pk PRIMARY key (id)
);

create table if not exists position_responsibility
(
    id          uuid          DEFAULT uuid_generate_v4(),
    from_date   date not null default current_date,
    thru_date   date,
    comment     text,
    position_id uuid not null references position (id),
    type_id     uuid not null references responsibility_type (id),
    CONSTRAINT position_responsibility_pk PRIMARY key (id)
);

create table if not exists position_classification_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT position_classification_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES position_classification_type (id),
    CONSTRAINT position_classification_type_pk PRIMARY key (id)
);

create table if not exists position_type_class
(
    id                      uuid            DEFAULT uuid_generate_v4(),
    from_date               date   not null default current_date,
    thru_date               date,
    standard_hours_per_week bigint not null default 40,
    type_id                 uuid   not null references position_type_class (id),
    position_type_id        uuid   not null references position_type (id),
    CONSTRAINT position_type_class_pk PRIMARY key (id)
);

create table if not exists position_fulfillment
(
    id                 uuid          DEFAULT uuid_generate_v4(),
    from_date          date not null default current_date,
    thru_date          date,
    comment            text,
    position_id        uuid not null references position (id),
    accepted_by_person uuid not null,
    CONSTRAINT position_fulfillment_pk PRIMARY key (id)
);

create table if not exists position_reporting_structure
(
    id           uuid          DEFAULT uuid_generate_v4(),
    from_date    date not null default current_date,
    thru_date    date,
    comment      text,
    primary_flag boolean,
    reports_to   uuid not null references position (id),
    manage_by    uuid not null references position (id),
    CONSTRAINT position_reporting_structure_pk PRIMARY key (id)
);

create table if not exists rate_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT rate_type_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES rate_type (id),
    CONSTRAINT rate_type_type_pk PRIMARY key (id)
);

create table if not exists pay_grade
(
    id        uuid DEFAULT uuid_generate_v4(),
    name      text not null
        CONSTRAINT pay_grade_name_not_empty CHECK (name <> ''),
    comment   text,
    parent_id UUID REFERENCES pay_grade (id),
    CONSTRAINT pay_grade_pk PRIMARY key (id)
);

create table if not exists salary_step
(
    id               uuid                    DEFAULT uuid_generate_v4(),
    step_sequence_id bigint         not null default 1,
    amount           numeric(17, 2) not null,
    date_modified    date           not null default current_date,
    pay_grade_id     uuid           not null references pay_grade (id),
    CONSTRAINT salary_step_pk PRIMARY key (id)
);

create table if not exists period_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text,
    parent_id   UUID REFERENCES period_type (id),
    constraint period_type_pk primary key (id)
);

create table if not exists position_type_rate
(
    id               uuid          DEFAULT uuid_generate_v4(),
    from_date        date not null default current_date,
    thru_date        date,
    rate             numeric(17, 2),
    position_type_id uuid not null references position_type (id),
    type_id          uuid not null references rate_type (id),
    salary_step_id   uuid not null references salary_step (id),
    period_type_id   uuid not null references period_type (id),
    CONSTRAINT position_type_rate_pk PRIMARY key (id)
);

create table if not exists pay_history
(
    id                               uuid          DEFAULT uuid_generate_v4(),
    from_date                        date not null default current_date,
    thru_date                        date,
    amount                           numeric(17, 2),
    comment                          text,
    period_type_id                   uuid not null references period_type (id),
    salary_step_id                   uuid not null references salary_step (id),
    employment_party_relationship_id uuid not null,
    CONSTRAINT pay_history_pk PRIMARY key (id)
);

create table if not exists benefit_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT benefit_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES benefit_type (id),
    CONSTRAINT benefit_type_pk PRIMARY key (id)
);

create table if not exists party_benefit
(
    id                           uuid          DEFAULT uuid_generate_v4(),
    from_date                    date not null default current_date,
    thru_date                    date,
    cost                         numeric(17, 2),
    actual_employer_paid_percent numeric(17, 2),
    available_time               timestamp,
    CONSTRAINT party_benefit_pk PRIMARY key (id)
);

create table if not exists deduction_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT deduction_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES deduction_type (id),
    CONSTRAINT deduction_type_pk PRIMARY key (id)
);

create table if not exists payment_method_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT payment_method_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES payment_method_type (id),
    CONSTRAINT payment_method_type_pk PRIMARY key (id)
);

create table if not exists deduction
(
    id          uuid DEFAULT uuid_generate_v4(),
    amount      numeric(17, 2),
    paycheck_id uuid not null,
    type_id     uuid not null references deduction_type (id),
    CONSTRAINT deduction_pk PRIMARY key (id)
);

create table if not exists payroll_preferences
(
    id                       uuid          DEFAULT uuid_generate_v4(),
    from_date                date not null default current_date,
    thru_date                date,
    percentage               numeric(17, 2),
    flat_amount              numeric(17, 2),
    routing_number           text,
    account_number           text,
    bank_name                text,
    employee_id              uuid not null,
    internal_organization_id uuid not null,
    type_id                  uuid not null references payment_method_type (id),
    period_type_id           uuid not null references period_type (id),
    CONSTRAINT payroll_preferences_pk PRIMARY key (id)
);

create table if not exists employment_application_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT employment_application_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES employment_application_status_type (id),
    CONSTRAINT employment_application_status_type_pk PRIMARY key (id)
);

create table if not exists employment_application_source_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT _type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES employment_application_source_type (id),
    CONSTRAINT _type_pk PRIMARY key (id)
);

create table if not exists employment_application
(
    id                         uuid          DEFAULT uuid_generate_v4(),
    application_date           date not null default current_date,
    referred_by_party_id       uuid,
    from_person_id             uuid not null,
    received_as_a_result_of_id uuid not null references employment_application_source_type (id),
    status_type_id             uuid not null references employment_application_status_type (id),
    position_id                uuid not null references position (id),
    CONSTRAINT employment_application_pk PRIMARY key (id)
);

create table if not exists qualification_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT qualification_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES qualification_type (id),
    CONSTRAINT qualification_type_pk PRIMARY key (id)
);

create table if not exists skill_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT skill_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES skill_type (id),
    CONSTRAINT skill_type_pk PRIMARY key (id)
);

create table if not exists training_class_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT training_class_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES training_class_type (id),
    CONSTRAINT training_class_type_pk PRIMARY key (id)
);

create table if not exists party_qualification
(
    id        uuid          DEFAULT uuid_generate_v4(),
    from_date date not null default current_date,
    thru_date date,
    party_id  uuid not null,
    type_id   uuid not null references qualification_type (id),
    CONSTRAINT party_qualification_pk PRIMARY key (id)
);

create table if not exists person_training
(
    id                    uuid          DEFAULT uuid_generate_v4(),
    from_date             date not null default current_date,
    thru_date             date,
    received_by_person_id uuid not null,
    type_id               uuid not null references training_class_type (id),
    CONSTRAINT person_training_pk PRIMARY key (id)
);

create table if not exists resume
(
    id          uuid          DEFAULT uuid_generate_v4(),
    resume_date date not null default current_date,
    resume_text text not null
        constraint resume_text_not_empty check (resume_text <> ''),
    CONSTRAINT resume_pk PRIMARY key (id)
);

create table if not exists performance_review_item_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT performance_review_item_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES performance_review_item_type (id),
    CONSTRAINT performance_review_item_type_pk PRIMARY key (id)
);

create table if not exists rating_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT rating_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES rating_type (id),
    CONSTRAINT rating_type_pk PRIMARY key (id)
);

create table if not exists performance_note_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT performance_note_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES performance_note_type (id),
    CONSTRAINT performance_note_type_pk PRIMARY key (id)
);

create table if not exists performance_review
(
    id               uuid          DEFAULT uuid_generate_v4(),
    from_date        date not null default current_date,
    thru_date        date,
    comment          text not null,
    pay_history_id   uuid not null references pay_history (id),
    bonus_id         uuid,
    position_id      uuid references position (id),
    manager_role_id  uuid not null,
    employee_role_id uuid not null,
    CONSTRAINT performance_review_pk PRIMARY key (id)
);

create table if not exists performance_view_item
(
    id             uuid            DEFAULT uuid_generate_v4(),
    sequence_id    bigint not null default 1,
    comment        text,
    type_id        uuid   not null references performance_review_item_type (id),
    rating_type_id uuid   not null references rating_type (id),
    CONSTRAINT performance_view_item_pk PRIMARY key (id)
);

create table if not exists performance_note
(
    id                 uuid          DEFAULT uuid_generate_v4(),
    from_date          date not null default current_date,
    thru_date          date,
    communication_date date not null default current_date,
    comment            text not null
        constraint performance_note_comment_not_empty check (comment <> ''),
    CONSTRAINT performance_note_pk PRIMARY key (id)
);

create table if not exists valid_responsibility
(
    id                     uuid          DEFAULT uuid_generate_v4(),
    comment                text,
    from_date              date not null default current_date,
    thru_date              date,
    position_type_id       uuid not null references position_type (id),
    responsibility_type_id uuid not null references responsibility_type (id),
    CONSTRAINT valid_responsibility_pk PRIMARY key (id)
);
