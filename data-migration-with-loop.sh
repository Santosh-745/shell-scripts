
!/bin/bash

export SOURCE_DB_URL="postgres://azodha:9VIgWlt0F5DcXpas@development-platform.cbqnd1uwbvzi.us-west-2.rds.amazonaws.com:5432/azodha"

psql "$SOURCE_DB_URL" -c "\copy (
    select \"sourceApp\", 
           \"organizationId\", 
           \"eventType\", 
           \"eventSubType\", 
           \"eventData\", 
           \"externalUserId\", 
           \"sessionId\", 
           \"createdAt\" 
    from \"AppLog\" 
    limit 100
) to 'AppLog.csv' csv header;"

psql "$SOURCE_DB_URL" -c "\copy (
    select \"sourceApp\", 
           \"eventType\", 
           \"eventSubType\", 
           \"eventData\", 
           \"personId\", 
           \"externalUserId\", 
           \"authenticationId\", 
           \"organizationId\", 
           \"createdAt\", 
           \"sessionId\" 
    from \"EventLog\" 
    limit 100
) to 'EventLog.csv' csv header;"

LOGGER_TABLES=(
    "AppLog"
    "EventLog"
)

LOGGER_TABLE_COLUMNS=(
    "(\"sourceApp\",\"organizationId\",\"eventType\",\"eventSubType\",\"eventData\",\"externalUserId\",\"sessionId\",\"createdAt\")"
    "(\"sourceApp\",\"eventType\",\"eventSubType\",\"eventData\",\"personId\",\"externalUserId\",\"authenticationId\",\"organizationId\",\"createdAt\",\"sessionId\")"
)

for key in "${!LOGGER_TABLES[@]}"; do
    # echo "KEY: $key || VALUE: ${LOGGER_TABLES[$key]} || KEbjhdsbg: ${LOGGER_TABLE_COLUMNS[$key]}"
    psql "$TARGET_DB_URL" -c "\copy \"${LOGGER_TABLES[$key]}\"${LOGGER_TABLE_COLUMNS[$key]} from './${LOGGER_TABLES[$key]}.csv' DELIMITER ',' CSV HEADER;"
done
