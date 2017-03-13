create table if not exists position_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT position_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT position_type_pk PRIMARY key(id)
);

create table if not exists position_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT position_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT position_status_type_pk PRIMARY key(id)
);

create table if not exists responsibility_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT responsibility_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT responsibility_type_pk PRIMARY key(id)
);

create table if not exists position(
  id uuid DEFAULT uuid_generate_v4(),
  estimated_from_date date not null default current_date,
  estimated_thru_date date,
  salary_flag boolean,
  exempt_flag boolean,
  fulltime_flag boolean,
  actual_from_date date not null default current_date,
  actual_thru_date date,
  approved_thru uuid not null,
  described_by uuid not null references position_type(id),
  in_the_state_of uuid not null references position_status_type(id),
  within_organization uuid not null,
  CONSTRAINT position_pk PRIMARY key(id)
);

create table if not exists position_responsibility(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  comment text,
  associated_with_position uuid not null references position(id),
  defined_by uuid not null references responsibility_type(id),
  CONSTRAINT position_responsibility_pk PRIMARY key(id)
);

create table if not exists position_classification_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT position_classification_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT position_classification_type_pk PRIMARY key(id)
);

create table if not exists position_type_class(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  standard_hours_per_week bigint not null default 40,
  for_position_type uuid not null references position_type (id),
  defined_by uuid not null references position_classification_type(id),
  CONSTRAINT _pk PRIMARY key(id)
);

create table if not exists position_fulfillment(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  comment text,
  fullfilment_of uuid not null references position(id),
  accepted_by_person uuid not null,
  CONSTRAINT position_fulfillment_pk PRIMARY key(id)
);

create table if not exists positition_reporting_structure(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  comment text,
  primary_flag boolean,
  reports_to uuid not null references position(id),
  manage_by uuid not null references position(id),
  CONSTRAINT positition_reporting_structure_pk PRIMARY key(id)
);

create table if not exists rate_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT rate_type_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT rate_type_type_pk PRIMARY key(id)
);

create table if not exists pay_grade (
  id uuid DEFAULT uuid_generate_v4(),
  name text not null CONSTRAINT pay_grade_name_not_empty CHECK (name <> ''),
  description text,
  CONSTRAINT pay_grade_pk PRIMARY key(id)
);

create table if not exists salary_step(
  id uuid DEFAULT uuid_generate_v4(),
  step_sequence_id bigint not null default 1,
  amount double precision not null,
  date_modified date not null default current_date,
  part_of_pay_grade uuid not null references pay_grade(id),
  CONSTRAINT salary_step_pk PRIMARY key(id)
);
create table if not exists position_type_rate(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  rate double precision,
  for_position_type uuid not null references position_type(id),
  for_rate_type uuid not null references rate_type(id),
  associated_with_salary_step uuid not null references salary_step(id),
  for_period_type uuid not null,
  CONSTRAINT position_type_rate_pk PRIMARY key(id)
);

create table if not exists pay_history(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  amount double precision,
  comment text,
  for_period_type uuid not null,
  assoicated_with_salary_step uuid not null references salary_step(id),
  record_for_employment_roie uuid not null,
  CONSTRAINT pay_history_pk PRIMARY key(id)
);
