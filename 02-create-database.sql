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
