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
  CONSTRAINT position_type_class_pk PRIMARY key(id)
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

create table if not exists benefity_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT benefit_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT benefit_type_pk PRIMARY key(id)
);

create table if not exists party_benefit(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  cost double precision,
  actual_employer_paid_percent double precision,
  available_time timestamp,
  CONSTRAINT party_benefit_pk PRIMARY key(id)
);

create table if not exists deduction_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT deduction_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT deduction_type_pk PRIMARY key(id)
);

create table if not exists payment_method_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT payment_method_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT payment_method_type_pk PRIMARY key(id)
);

create table if not exists deduction(
  id uuid DEFAULT uuid_generate_v4(),
  amount double precision,
  reduction_of_paycheck uuid not null,
  definect_by uuid not null references deduction_type (id),
  CONSTRAINT deduction_pk PRIMARY key(id)
);

create table if not exists payroll_preferences(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  percentage double precision,
  flat_amount double precision,
  routing_number text,
  account_number text,
  bank_name text,
  for_employee_roll uuid not null,
  of_internal_organization_roll uuid not null,
  defined_by uuid not null references payment_method_type(id),
  period_type uuid not null,
  CONSTRAINT payrool_preferences_pk PRIMARY key(id)
);

create table if not exists employment_application_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT employment_application_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT employment_application_status_type_pk PRIMARY key(id)
);

create table if not exists employment_application_source_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT _type_description_not_empty CHECK (description <> ''),
  CONSTRAINT _type_pk PRIMARY key(id)
);

create table if not exists employment_application(
  id uuid DEFAULT uuid_generate_v4(),
  application_date date not null default current_date,
  referred_by_party uuid,
  from_person uuid not null,
  received_as_a_result_of uuid not null references employment_application_source_type(id),
  status_of uuid not null references employment_application_status_type(id),
  for_the_position_of uuid not null references position(id),
  CONSTRAINT employment_application_pk PRIMARY key(id)
);

create table if not exists qualification_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT qualification_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT qualification_type_pk PRIMARY key(id)
);

create table if not exists skill_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT skill_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT skill_type_pk PRIMARY key(id)
);

create table if not exists training_class_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT training_class_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT training_class_type_pk PRIMARY key(id)
);

create table if not exists party_qualification(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  held_by_party uuid not null,
  described_by uuid not null references qualification_type,
  CONSTRAINT party_qualification_pk PRIMARY key(id)
);

create table if not exists person_training(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  received_by_person uuid not null,
  described_by uuid not null references training_class_type(id),
  CONSTRAINT person_training_pk PRIMARY key(id)
);

create table if not exists resume(
  id uuid DEFAULT uuid_generate_v4(),
  resume_date date not null default current_date,
  resume_text text not null constraint resume_text_not_empty check (resume_text <> ''),
  CONSTRAINT resume_pk PRIMARY key(id)
);

create table if not exists performance_review_item_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT performance_review_item_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT performance_review_item_type_pk PRIMARY key(id)
);

create table if not exists rating_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT rating_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT rating_type_pk PRIMARY key(id)
);

create table if not exists performance_note_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT performance_note_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT performance_note_type_pk PRIMARY key(id)
);

create table if not exists performance_review(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  comment text not null,
  affecting_pay_history uuid not null references pay_history(id),
  resulting_in_a_bonuse_of uuid,
  resulting_ing_position uuid references position(id),
  from_manager_role uuid not null,
  for_employee_role uuid not null,
  CONSTRAINT performance_review_pk PRIMARY key(id)
);

create table if not exists performance_view_item(
  id uuid DEFAULT uuid_generate_v4(),
  sequence_id bigint not null default 1,
  comment text,
  described_by uuid not null references performance_review_item_type(id),
  scored_using uuid not null references rating_type(id),
  CONSTRAINT performance_view_item_pk PRIMARY key(id)
);

create table if not exists performance_note(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  communication_date date not null default current_date,
  comment text not null constraint performance_note_comment_not_empty check(comment <> ''),
  CONSTRAINT performance_note_pk PRIMARY key(id)
);
