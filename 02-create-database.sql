create table if not exists position_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT position_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT position_type_pk PRIMARY key(id)
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
  CONSTRAINT position_pk PRIMARY key(id)
);

create table if not exists position_responsibility(
  id uuid DEFAULT uuid_generate_v4(),
  CONSTRAINT position_responsibility_pk PRIMARY key(id)
);
