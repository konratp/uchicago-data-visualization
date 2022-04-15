# data

Place data file(s) in this folder.

Then, include metadata about your dataset including information on provenance, codebook, etc.

The codebook for your data file(s) using the following format.

## name of data file

|variable                            |class     |description |
|:-----------------------------------|:---------|:-----------|
|project_reference                   |character |Project reference is an aggregation of several information (YYYY-X-AAAA-KKKKK-NNNNN) where YYYY represent year, X represents the round within the call year, AAAA represents the National Agency managing the project, KKKKK is the key action code and NNNNNN is an auto generated number |
|academic_year                       |character | Only relevant for higher education (KA103, KA107) - Year-Month (YYYY-MM) |
|mobility_start_month                |character | Year-Month (YYYY-MM) |
|mobility_end_month                  |character | Year-Month (YYYY-MM) |
|mobility_duration                   |double    | Exact duration of the mobility in calendar days (date2-date1) |
|activity_mob                        |character |.           |
|field_of_education                  |character | Participant field of education |
|participant_nationality             |character | Code (DE, FR, BE, …..) |
|education_level                     |character | Included where relevant |
|participant_gender                  |character | Male/Female/Undefined |
|participant_profile                 |character | Staff or learner, training can be retrieved from activity field |
|special_needs                       |character | Yes/no|
|fewer_opportunities                 |character | Yes/no |
|group_leader                        |character | Yes/no |
|participant_age                     |double    |Age at start of mobility in years |
|sending_country_code                |character | Code (DE, FR, BE, …..) |
|sending_city                        |character |City of sending organisation|
|sending_organization                |character | Name of organisation |
|sending_organisation_erasmus_code   |character | Organisation Erasmus code |
|receiving_country_code              |character | Code (DE, FR, BE, …..) |
|receiving_city                      |character | City of receiving organisationn |
|receiving_organization              |character | Name of organisation |
|receiving_organisation_erasmus_code |character | Organisation Erasmus code |
|participants                        |double    | Total number of participants |
