CREATE TABLE concept (
  concept_id			INTEGER		 ,
  concept_name			VARCHAR(255) ,
  domain_id				VARCHAR(20)	 ,
  vocabulary_id			VARCHAR(20)	 ,
  concept_class_id		VARCHAR(20)	 ,
  standard_concept		VARCHAR(1)	 ,
  concept_code			VARCHAR(50)	 ,
  valid_start_date		DATE		 ,
  valid_end_date		DATE		 ,
  invalid_reason		VARCHAR(1)	)
 ;

CREATE TABLE condition_occurrence
(
  condition_occurrence_id		BIGINT			 ,
  person_id						BIGINT			 ,
  condition_concept_id			INTEGER			 ,
  condition_start_date			DATE			 ,
  condition_start_datetime		TIMESTAMP		 ,
  condition_end_date			DATE			 ,
  condition_end_datetime		TIMESTAMP		 ,
  condition_type_concept_id		INTEGER			 ,
  condition_status_concept_id	INTEGER			 ,
  stop_reason					VARCHAR(20)		 ,
  provider_id					BIGINT			 ,
  visit_occurrence_id			BIGINT			 ,
  visit_detail_id               BIGINT	     	 ,
  condition_source_value		VARCHAR(50)		 ,
  condition_source_concept_id	INTEGER			 ,
  condition_status_source_value	VARCHAR(50)		
)
;

CREATE TABLE drug_exposure
(
  drug_exposure_id				BIGINT			 	 ,
  person_id						BIGINT			 	 ,
  drug_concept_id				INTEGER			  	 ,
  drug_exposure_start_date		DATE			     ,
  drug_exposure_start_datetime	TIMESTAMP		 	 ,
  drug_exposure_end_date		DATE			     ,
  drug_exposure_end_datetime	TIMESTAMP		  	 ,
  verbatim_end_date				DATE			     ,
  drug_type_concept_id			INTEGER			  	 ,
  stop_reason					VARCHAR(20)			 ,
  refills						INTEGER		  		 ,
  quantity						NUMERIC			     ,
  days_supply					INTEGER		  		 ,
  sig							TEXT				 ,
  route_concept_id				INTEGER				 ,
  lot_number					VARCHAR(50)	 		 ,
  provider_id					BIGINT			  	 ,
  visit_occurrence_id			BIGINT			  	 ,
  visit_detail_id               BIGINT       		 ,
  drug_source_value				VARCHAR(50)	  		 ,
  drug_source_concept_id		INTEGER			  	 ,
  route_source_value			VARCHAR(50)	  		 ,
  dose_unit_source_value		VARCHAR(50)	  		
)
;

CREATE TABLE person
(
  person_id						BIGINT	  	, 
  gender_concept_id				INTEGER	  	,
  year_of_birth					INTEGER	  	,
  month_of_birth				INTEGER	  	,
  day_of_birth					INTEGER	  	,
  birth_datetime				TIMESTAMP	,
  race_concept_id				INTEGER		,
  ethnicity_concept_id			INTEGER	  	,
  location_id					BIGINT		,
  provider_id					BIGINT		,
  care_site_id					BIGINT		,
  person_source_value			VARCHAR(50)	,
  gender_source_value			VARCHAR(50) ,
  gender_source_concept_id	  	INTEGER		,
  race_source_value				VARCHAR(50) ,
  race_source_concept_id		INTEGER		,
  ethnicity_source_value		VARCHAR(50) ,
  ethnicity_source_concept_id	INTEGER		
)
;

CREATE TABLE visit_occurrence
(
  visit_occurrence_id			BIGINT			 ,
  person_id						BIGINT			 ,
  visit_concept_id				INTEGER			 ,
  visit_start_date				DATE			 ,
  visit_start_datetime			TIMESTAMP		 ,
  visit_end_date				DATE			 ,
  visit_end_datetime			TIMESTAMP		 ,
  visit_type_concept_id			INTEGER			 ,
  provider_id					BIGINT			 ,
  care_site_id					BIGINT			 ,
  visit_source_value			VARCHAR(50)		 ,
  visit_source_concept_id		INTEGER			 ,
  admitted_from_concept_id      INTEGER     	 ,   
  admitted_from_source_value    VARCHAR(50) 	 ,
  discharge_to_source_value		VARCHAR(50)		 ,
  discharge_to_concept_id		INTEGER   		 ,
  preceding_visit_occurrence_id	BIGINT 			
)
;

CREATE TABLE death
(
  person_id                 BIGINT	  ,
  death_date	            DATE	  ,
  death_datetime	        TIMESTAMP ,
  death_type_concept_id	    INTEGER	  ,
  cause_concept_id	        BIGINT	  ,
  cause_source_value	    INTEGER	  ,
  cause_source_concept_id	BIGINT
)
;

-- constrains primary key

ALTER TABLE concept ADD CONSTRAINT xpk_concept PRIMARY KEY (concept_id);

ALTER TABLE condition_occurrence ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY ( condition_occurrence_id ) ;

ALTER TABLE drug_exposure ADD CONSTRAINT xpk_drug_exposure PRIMARY KEY ( drug_exposure_id ) ;

ALTER TABLE person ADD CONSTRAINT xpk_person PRIMARY KEY ( person_id ) ;

ALTER TABLE visit_occurrence ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY ( visit_occurrence_id ) ;
