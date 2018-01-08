
DROP TABLE IF EXISTS "application";
CREATE TABLE "application" (
  "id" varchar(36) NOT NULL,
  "patent_id" varchar(20) NOT NULL,
  "type" varchar(20) DEFAULT NULL,
  "number" varchar(64) DEFAULT NULL,
  "country" varchar(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "id_transformed" varchar(36) DEFAULT NULL,
  "number_transformed" varchar(64) DEFAULT NULL,
  "series_code_transformed_from_type" varchar(20) DEFAULT NULL,
  PRIMARY KEY ("id","patent_id")
);

CREATE INDEX "patent_id" ON "application" ("patent_id");
CREATE INDEX "app_idx1" ON "application" ("type","number");
CREATE INDEX "app_idx2" ON "application" ("date");
CREATE INDEX "app_idx3" ON "application" ("number_transformed");


DROP TABLE IF EXISTS "assignee";
CREATE TABLE "assignee" (
  "id" varchar(36) NOT NULL,
  "type" int DEFAULT NULL,
  "name_first" varchar(64) DEFAULT NULL,
  "name_last" varchar(64) DEFAULT NULL,
  "organization" varchar(256) DEFAULT NULL,
  PRIMARY KEY ("id")
);


DROP TABLE IF EXISTS "botanic";
CREATE TABLE "botanic" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) NOT NULL,
  "latin_name" varchar(128) DEFAULT NULL,
  "variety" varchar(128) DEFAULT NULL,
  PRIMARY KEY ("uuid"),
  CONSTRAINT "ix_botanic_patent_id" UNIQUE  ("patent_id")
);



DROP TABLE IF EXISTS "brf_sum_text";
CREATE TABLE "brf_sum_text" (
  "uuid" varchar(36) CHARACTER SET utf8 NOT NULL,
  "patent_id" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  "text" text CHARACTER SET utf8,
  PRIMARY KEY ("uuid")
);



DROP TABLE IF EXISTS "claim";
CREATE TABLE "claim" (
  "uuid" varchar(36) CHARACTER SET utf8 NOT NULL,
  "patent_id" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  "text" text CHARACTER SET utf8,
  "dependent" int DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  "exemplary" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "ix_claim_patent_id" ON "claim" ("patent_id");



DROP TABLE IF EXISTS "cpc_current";
CREATE TABLE "cpc_current" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "section_id" varchar(10) DEFAULT NULL,
  "subsection_id" varchar(20) DEFAULT NULL,
  "group_id" varchar(20) DEFAULT NULL,
  "subgroup_id" varchar(20) DEFAULT NULL,
  "category" varchar(36) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "cpc_current" ("patent_id");
CREATE INDEX "subsection_id" ON "cpc_current" ("subsection_id");
CREATE INDEX "group_id" ON "cpc_current" ("group_id");
CREATE INDEX "subgroup_id" ON "cpc_current" ("subgroup_id");
CREATE INDEX "ix_cpc_current_sequence" ON "cpc_current" ("sequence");
CREATE INDEX "ix_cpc_current_category" ON "cpc_current" ("category");



DROP TABLE IF EXISTS "cpc_group";
CREATE TABLE "cpc_group" (
  "id" varchar(20) NOT NULL,
  "title" varchar(256) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "cpc_subgroup";
CREATE TABLE "cpc_subgroup" (
  "id" varchar(20) NOT NULL,
  "title" varchar(512) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "cpc_subsection";
CREATE TABLE "cpc_subsection" (
  "id" varchar(20) NOT NULL,
  "title" varchar(256) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "draw_desc_text";
CREATE TABLE "draw_desc_text" (
  "uuid" varchar(36) CHARACTER SET utf8 NOT NULL,
  "patent_id" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  "text" text CHARACTER SET utf8,
  "sequence" int check ("sequence" > 0) NOT NULL
);



DROP TABLE IF EXISTS "figures";
CREATE TABLE "figures" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) NOT NULL,
  "num_figures" int DEFAULT NULL,
  "num_sheets" int DEFAULT NULL,
  PRIMARY KEY ("uuid"),
  CONSTRAINT "ix_figures_patentid" UNIQUE  ("patent_id")
);



DROP TABLE IF EXISTS "foreigncitation";
CREATE TABLE "foreigncitation" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "number" varchar(64) DEFAULT NULL,
  "country" varchar(10) DEFAULT NULL,
  "category" varchar(20) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "foreigncitation" ("patent_id");



DROP TABLE IF EXISTS "foreign_priority";
CREATE TABLE "foreign_priority" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) NOT NULL,
  "sequence" int DEFAULT NULL,
  "kind" varchar(10) DEFAULT NULL,
  "number" varchar(64) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "country" varchar(20) DEFAULT NULL,
  "country_transformed" varchar(20) DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "ix_forpri_date" ON "foreign_priority" ("date");



DROP TABLE IF EXISTS "government_interest";
CREATE TABLE "government_interest" (
  "patent_id" varchar(255) NOT NULL,
  "gi_statement" text,
  PRIMARY KEY ("patent_id")
);



DROP TABLE IF EXISTS "government_organization";
CREATE TABLE "government_organization" (
  "organization_id" int NOT NULL,
  "name" varchar(255) DEFAULT NULL,
  "level_one" varchar(255) DEFAULT NULL,
  "level_two" varchar(255) DEFAULT NULL,
  "level_three" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("organization_id")
);



DROP TABLE IF EXISTS "inventor";
CREATE TABLE "inventor" (
  "id" varchar(36) NOT NULL,
  "name_first" varchar(64) DEFAULT NULL,
  "name_last" varchar(64) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "ipcr";
CREATE TABLE "ipcr" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "classification_level" varchar(20) DEFAULT NULL,
  "section" varchar(20) DEFAULT NULL,
  "ipc_class" varchar(20) DEFAULT NULL,
  "subclass" varchar(20) DEFAULT NULL,
  "main_group" varchar(20) DEFAULT NULL,
  "subgroup" varchar(20) DEFAULT NULL,
  "symbol_position" varchar(20) DEFAULT NULL,
  "classification_value" varchar(20) DEFAULT NULL,
  "classification_status" varchar(20) DEFAULT NULL,
  "classification_data_source" varchar(20) DEFAULT NULL,
  "action_date" date DEFAULT NULL,
  "ipc_version_indicator" date DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "ipcr" ("patent_id");
CREATE INDEX "ix_ipcr_sequence" ON "ipcr" ("sequence");
CREATE INDEX "ix_ipcr_action_date" ON "ipcr" ("action_date");
CREATE INDEX "ix_ipcr_ipc_version_indicator" ON "ipcr" ("ipc_version_indicator");



DROP TABLE IF EXISTS "lawyer";
CREATE TABLE "lawyer" (
  "id" varchar(36) NOT NULL,
  "name_first" varchar(64) DEFAULT NULL,
  "name_last" varchar(64) DEFAULT NULL,
  "organization" varchar(64) DEFAULT NULL,
  "country" varchar(10) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "location";
CREATE TABLE "location" (
  "id" varchar(128) NOT NULL,
  "city" varchar(128) DEFAULT NULL,
  "state" varchar(20) DEFAULT NULL,
  "country" varchar(10) DEFAULT NULL,
  "latitude" double precision DEFAULT NULL,
  "longitude" double precision DEFAULT NULL,
  "county" varchar(60) DEFAULT NULL,
  "state_fips" varchar(2) DEFAULT NULL,
  "county_fips" varchar(3) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE INDEX "ix_location_country" ON "location" ("country");
CREATE INDEX "dloc_idx2" ON "location" ("city","state","country");
CREATE INDEX "dloc_idx1" ON "location" ("latitude","longitude");
CREATE INDEX "ix_location_state" ON "location" ("state");
CREATE INDEX "location_county" ON "location" ("county");
CREATE INDEX "location_state_fips" ON "location" ("state_fips");
CREATE INDEX "location_county_fips" ON "location" ("county_fips");



DROP TABLE IF EXISTS "location_assignee";
CREATE TABLE "location_assignee" (
  "location_id" varchar(128) DEFAULT NULL,
  "assignee_id" varchar(36) DEFAULT NULL
);

CREATE INDEX "location_id" ON "location_assignee" ("location_id");
CREATE INDEX "assignee_id" ON "location_assignee" ("assignee_id");



DROP TABLE IF EXISTS "location_inventor";
CREATE TABLE "location_inventor" (
  "location_id" varchar(128) DEFAULT NULL,
  "inventor_id" varchar(36) DEFAULT NULL
);

CREATE INDEX "location_id" ON "location_inventor" ("location_id");
CREATE INDEX "inventor_id" ON "location_inventor" ("inventor_id");



DROP TABLE IF EXISTS "mainclass";
CREATE TABLE "mainclass" (
  "id" varchar(20) NOT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "mainclass_current";
CREATE TABLE "mainclass_current" (
  "id" varchar(20) NOT NULL,
  "title" varchar(256) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "nber";
CREATE TABLE "nber" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "category_id" varchar(20) DEFAULT NULL,
  "subcategory_id" varchar(20) DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "nber" ("patent_id");
CREATE INDEX "category_id" ON "nber" ("category_id");
CREATE INDEX "subcategory_id" ON "nber" ("subcategory_id");



DROP TABLE IF EXISTS "nber_category";
CREATE TABLE "nber_category" (
  "id" varchar(20) NOT NULL,
  "title" varchar(512) DEFAULT NULL,
  PRIMARY KEY ("id")
);



DROP TABLE IF EXISTS "nber_subcategory";
CREATE TABLE "nber_subcategory" (
  "id" varchar(20) NOT NULL,
  "title" varchar(512) DEFAULT NULL,
  PRIMARY KEY ("id")
);


DROP TABLE IF EXISTS "non_inventor_applicant";
CREATE TABLE "non_inventor_applicant" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(36) NOT NULL,
  "rawlocation_id" varchar(36) NOT NULL,
  "lname" varchar(40) DEFAULT NULL,
  "fname" varchar(30) DEFAULT NULL,
  "organization" varchar(128) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  "designation" varchar(20) DEFAULT NULL,
  "applicant_type" varchar(30) DEFAULT NULL,
  PRIMARY KEY ("uuid"),
  CONSTRAINT "ix_noninvntappl_patentid" UNIQUE  ("patent_id")
);

CREATE INDEX "patent_id" ON "non_inventor_applicant" ("patent_id");
CREATE INDEX "rawlocation_id" ON "non_inventor_applicant" ("rawlocation_id");


DROP TABLE IF EXISTS "otherreference";
CREATE TABLE "otherreference" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "text" text,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
 ,
  FULLTEXT KEY "fti_text" ("text")

CREATE INDEX "patent_id" ON "otherreference" ("patent_id");
);


DROP TABLE IF EXISTS "patent";
CREATE TABLE "patent" (
  "id" varchar(20) NOT NULL,
  "type" varchar(100) DEFAULT NULL,
  "number" varchar(64) DEFAULT NULL,
  "country" varchar(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "abstract" text,
  "title" text,
  "kind" varchar(10) DEFAULT NULL,
  "num_claims" int DEFAULT NULL,
  "filename" varchar(120) DEFAULT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "pat_idx1" UNIQUE  ("type","number")
);

CREATE INDEX "pat_idx2" ON "patent" ("date");


DROP TABLE IF EXISTS "patent_assignee";
CREATE TABLE "patent_assignee" (
  "patent_id" varchar(20) DEFAULT NULL,
  "assignee_id" varchar(36) DEFAULT NULL
);

CREATE INDEX "ix_patent_assignee_patent_id" ON "patent_assignee" ("patent_id");
CREATE INDEX "ix_patent_assignee_assignee_id" ON "patent_assignee" ("assignee_id");


DROP TABLE IF EXISTS "patent_contractawardnumber";
CREATE TABLE "patent_contractawardnumber" (
  "patent_id" varchar(255) NOT NULL,
  "contract_award_number" varchar(255) NOT NULL,
  PRIMARY KEY ("patent_id","contract_award_number"),
  CONSTRAINT "patent_contractawardnumber_ibfk_1" FOREIGN KEY ("patent_id") REFERENCES "government_interest" ("patent_id") ON DELETE CASCADE
);


DROP TABLE IF EXISTS "patent_govintorg";
CREATE TABLE "patent_govintorg" (
  "patent_id" varchar(255) NOT NULL,
  "organization_id" int NOT NULL,
  PRIMARY KEY ("patent_id","organization_id")
 ,
  CONSTRAINT "patent_govintorg_ibfk_1" FOREIGN KEY ("patent_id") REFERENCES "government_interest" ("patent_id") ON DELETE CASCADE,
  CONSTRAINT "patent_govintorg_ibfk_2" FOREIGN KEY ("organization_id") REFERENCES "government_organization" ("organization_id") ON DELETE CASCADE
);

CREATE INDEX "organization_id" ON "patent_govintorg" ("organization_id");


DROP TABLE IF EXISTS "patent_inventor";
CREATE TABLE "patent_inventor" (
  "patent_id" varchar(20) DEFAULT NULL,
  "inventor_id" varchar(36) DEFAULT NULL
);

CREATE INDEX "patent_id" ON "patent_inventor" ("patent_id");
CREATE INDEX "inventor_id" ON "patent_inventor" ("inventor_id");


DROP TABLE IF EXISTS "patent_lawyer";
CREATE TABLE "patent_lawyer" (
  "patent_id" varchar(20) DEFAULT NULL,
  "lawyer_id" varchar(36) DEFAULT NULL
);

CREATE INDEX "patent_id" ON "patent_lawyer" ("patent_id");
CREATE INDEX "lawyer_id" ON "patent_lawyer" ("lawyer_id");


DROP TABLE IF EXISTS "pct_data";
CREATE TABLE "pct_data" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) NOT NULL,
  "rel_id" varchar(20) NOT NULL,
  "date" date DEFAULT NULL,
  "371_date" date DEFAULT NULL,
  "country" varchar(20) DEFAULT NULL,
  "kind" varchar(20) DEFAULT NULL,
  "doc_type" varchar(20) DEFAULT NULL,
  "102_date" date DEFAULT NULL,
  PRIMARY KEY ("uuid"),
  CONSTRAINT "ix_pctdat_patentid" UNIQUE  ("patent_id","rel_id")
);

CREATE INDEX "ix_pctdat_date" ON "pct_data" ("date");


DROP TABLE IF EXISTS "rawassignee";
CREATE TABLE "rawassignee" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "assignee_id" varchar(36) DEFAULT NULL,
  "rawlocation_id" varchar(128) DEFAULT NULL,
  "type" int DEFAULT NULL,
  "name_first" varchar(64) DEFAULT NULL,
  "name_last" varchar(64) DEFAULT NULL,
  "organization" varchar(256) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
  CREATE INDEX "patent_id" ON "rawassignee" ("patent_id")
  CREATE INDEX "assignee_id" ON "rawassignee" ("assignee_id")
  CREATE INDEX "rawlocation_id" ON "rawassignee" ("rawlocation_id")
  CREATE INDEX "ix_rawassignee_sequence" ON "rawassignee" ("sequence")
  CREATE INDEX "ix_organization" ON "rawassignee" ("organization"(255))
);


DROP TABLE IF EXISTS "rawexaminer";
CREATE TABLE "rawexaminer" (
  "uuid" varchar(36) NOT NULL DEFAULT '',
  "patent_id" varchar(20) CHARACTER SET utf8 NOT NULL,
  "name_first" varchar(30) DEFAULT NULL,
  "name_last" varchar(40) DEFAULT NULL,
  "role" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  "group" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "rawexaminer" ("patent_id");


DROP TABLE IF EXISTS "rawinventor";
CREATE TABLE "rawinventor" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "inventor_id" varchar(36) DEFAULT NULL,
  "rawlocation_id" varchar(128) DEFAULT NULL,
  "name_first" varchar(64) DEFAULT NULL,
  "name_last" varchar(64) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  "rule_47" varchar(20) DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "rawinventor" ("patent_id");
CREATE INDEX "inventor_id" ON "rawinventor" ("inventor_id");
CREATE INDEX "rawlocation_id" ON "rawinventor" ("rawlocation_id");
CREATE INDEX "ix_rawinventor_sequence" ON "rawinventor" ("sequence");


DROP TABLE IF EXISTS "rawlawyer";
CREATE TABLE "rawlawyer" (
  "uuid" varchar(36) CHARACTER SET utf8 NOT NULL,
  "lawyer_id" varchar(36) CHARACTER SET utf8 DEFAULT NULL,
  "patent_id" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  "name_first" varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  "name_last" varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  "organization" varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  "country" varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "ix_rawlawyer_patent_id" ON "rawlawyer" ("patent_id");
CREATE INDEX "ix_rawlawyer_sequence" ON "rawlawyer" ("sequence");


DROP TABLE IF EXISTS "rawlocation";
CREATE TABLE "rawlocation" (
  "id" varchar(128) NOT NULL,
  "location_id" varchar(128) DEFAULT NULL,
  "city" varchar(128) DEFAULT NULL,
  "state" varchar(20) DEFAULT NULL,
  "country" varchar(10) DEFAULT NULL,
  "country_transformed" varchar(10) DEFAULT NULL,
  "location_id_transformed" varchar(128) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE INDEX "location_id" ON "rawlocation" ("location_id");
CREATE INDEX "loc_idx1" ON "rawlocation" ("city","state","country");
CREATE INDEX "ix_rawlocation_state" ON "rawlocation" ("state");
CREATE INDEX "ix_rawlocation_country" ON "rawlocation" ("country");
CREATE INDEX "rawlocation_location_id_transformed" ON "rawlocation" ("location_id_transformed");
CREATE INDEX "ix_rawlocation_country_transformed_state" ON "rawlocation" ("country_transformed","state");


DROP TABLE IF EXISTS "rel_app_text";
CREATE TABLE "rel_app_text" (
  "uuid" varchar(36) CHARACTER SET utf8 NOT NULL,
  "patent_id" varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  "text" text CHARACTER SET utf8,
  "sequence" int check ("sequence" > 0) NOT NULL,
  PRIMARY KEY ("uuid")
);


DROP TABLE IF EXISTS "subclass";
CREATE TABLE "subclass" (
  "id" varchar(20) NOT NULL,
  PRIMARY KEY ("id")
);


DROP TABLE IF EXISTS "subclass_current";
CREATE TABLE "subclass_current" (
  "id" varchar(20) NOT NULL,
  "title" varchar(512) DEFAULT NULL,
  PRIMARY KEY ("id")
);


DROP TABLE IF EXISTS "usapplicationcitation";
CREATE TABLE "usapplicationcitation" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "application_id" varchar(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "name" varchar(64) DEFAULT NULL,
  "kind" varchar(10) DEFAULT NULL,
  "number" varchar(64) DEFAULT NULL,
  "country" varchar(10) DEFAULT NULL,
  "category" varchar(20) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  "application_id_transformed" varchar(36) DEFAULT NULL,
  "number_transformed" varchar(64) DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "usapplicationcitation" ("patent_id");
CREATE INDEX "ix_usapplicationcitation_application_id" ON "usapplicationcitation" ("application_id");
CREATE INDEX "ix_number_transformed" ON "usapplicationcitation" ("number_transformed");


DROP TABLE IF EXISTS "uspatentcitation";
CREATE TABLE "uspatentcitation" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "citation_id" varchar(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "name" varchar(64) DEFAULT NULL,
  "kind" varchar(10) DEFAULT NULL,
  "country" varchar(10) DEFAULT NULL,
  "category" varchar(20) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "uspatentcitation" ("patent_id");
CREATE INDEX "ix_uspatentcitation_citation_id" ON "uspatentcitation" ("citation_id");


DROP TABLE IF EXISTS "uspc";
CREATE TABLE "uspc" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "mainclass_id" varchar(20) DEFAULT NULL,
  "subclass_id" varchar(20) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "uspc" ("patent_id");
CREATE INDEX "mainclass_id" ON "uspc" ("mainclass_id");
CREATE INDEX "subclass_id" ON "uspc" ("subclass_id");
CREATE INDEX "ix_uspc_sequence" ON "uspc" ("sequence");


DROP TABLE IF EXISTS "uspc_current";
CREATE TABLE "uspc_current" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "mainclass_id" varchar(20) DEFAULT NULL,
  "subclass_id" varchar(20) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "uspc_current" ("patent_id");
CREATE INDEX "mainclass_id" ON "uspc_current" ("mainclass_id");
CREATE INDEX "subclass_id" ON "uspc_current" ("subclass_id");
CREATE INDEX "ix_uspc_current_sequence" ON "uspc_current" ("sequence");


DROP TABLE IF EXISTS "usreldoc";
CREATE TABLE "usreldoc" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) DEFAULT NULL,
  "doctype" varchar(64) DEFAULT NULL,
  "relkind" varchar(64) DEFAULT NULL,
  "reldocno" varchar(64) DEFAULT NULL,
  "country" varchar(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "status" varchar(20) DEFAULT NULL,
  "sequence" int DEFAULT NULL,
  "kind" varchar(10) DEFAULT NULL,
  PRIMARY KEY ("uuid")
);

CREATE INDEX "patent_id" ON "usreldoc" ("patent_id");
CREATE INDEX "ix_usreldoc_country" ON "usreldoc" ("country");
CREATE INDEX "ix_usreldoc_doctype" ON "usreldoc" ("doctype");
CREATE INDEX "ix_usreldoc_date" ON "usreldoc" ("date");
CREATE INDEX "ix_usreldoc_reldocno" ON "usreldoc" ("reldocno");
CREATE INDEX "ix_usreldoc_sequence" ON "usreldoc" ("sequence");


DROP TABLE IF EXISTS "us_term_of_grant";
CREATE TABLE "us_term_of_grant" (
  "uuid" varchar(36) NOT NULL,
  "patent_id" varchar(20) NOT NULL,
  "lapse_of_patent" varchar(20) DEFAULT NULL,
  "disclaimer_date" date DEFAULT NULL,
  "term_disclaimer" varchar(128) DEFAULT NULL,
  "term_grant" varchar(128) DEFAULT NULL,
  "term_extension" varchar(20) DEFAULT NULL,
  PRIMARY KEY ("uuid"),
  CONSTRAINT "ix_ustergra_patentid" UNIQUE  ("patent_id")
);

CREATE INDEX "ix_ustergra_date" ON "us_term_of_grant" ("disclaimer_date");


DROP TABLE IF EXISTS "wipo";
CREATE TABLE "wipo" (
  "patent_id" varchar(20) NOT NULL,
  "field_id" varchar(3) DEFAULT NULL,
  "sequence" int check ("sequence" > 0) NOT NULL,
  PRIMARY KEY ("patent_id","sequence")
);

CREATE INDEX "ix_wipo_field_id" ON "wipo" ("field_id");


DROP TABLE IF EXISTS "wipo_field";
CREATE TABLE "wipo_field" (
  "id" varchar(3) NOT NULL DEFAULT '',
  "sector_title" varchar(60) DEFAULT NULL,
  "field_title" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE INDEX "ix_wipo_field_sector_title" ON "wipo_field" ("sector_title");
CREATE INDEX "ix_wipo_field_field_title" ON "wipo_field" ("field_title");


