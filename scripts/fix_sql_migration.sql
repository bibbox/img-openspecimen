use openspecimen;

CREATE OR REPLACE VIEW openspecimen.cpr_view AS
SELECT 
    cpr.IDENTIFIER AS cpr_id,
    cpr.COLLECTION_PROTOCOL_ID AS cp_id,
    cpr.PARTICIPANT_ID AS participant_id,
    p.FIRST_NAME AS first_name,
    p.MIDDLE_NAME AS middle_name,
    p.LAST_NAME AS last_name,
    p.BIRTH_DATE AS dob,
    p.SOCIAL_SECURITY_NUMBER AS ssn,
    cpr.ACTIVITY_STATUS AS activity_status,
    p.GENDER AS gender,
    p.GENOTYPE AS genotype,
    cpr.REGISTRATION_DATE AS registration_date,
    cpr.PROTOCOL_PARTICIPANT_ID AS ppid,
    p.VITAL_STATUS AS vital_status,
    p.DEATH_DATE AS death_date,
    p.EMPI_ID AS empi_id,
    cpr.BARCODE AS barcode,
    cpr.CONSENT_SIGN_DATE AS consent_sign_date,
    cpr.CONSENT_WITNESS AS consent_witness,
    cpr.CONSENT_COMMENTS AS consent_comments,
    cpr.EXTERNAL_SUBJECT_ID AS external_subject_id,
    cpr.SITE_ID AS site_id,
    cpr.CREATION_TIME AS creation_time,
    cpr.CREATOR AS creator,
    (
        CASE
            WHEN (cpr.UPDATE_TIME IS NULL) THEN p.UPDATE_TIME
            WHEN (p.UPDATE_TIME IS NULL) THEN cpr.UPDATE_TIME
            WHEN (cpr.UPDATE_TIME < p.UPDATE_TIME) THEN p.UPDATE_TIME
            ELSE cpr.UPDATE_TIME
        END
    ) AS update_time,
    (
        CASE
            WHEN (cpr.UPDATE_TIME IS NULL) THEN p.UPDATER
            WHEN (p.UPDATE_TIME IS NULL) THEN cpr.UPDATER
            WHEN (cpr.UPDATE_TIME < p.UPDATE_TIME) THEN p.UPDATER
            ELSE cpr.UPDATER
        END
    ) AS updater,
    NULL AS email_address, -- Adding the new column "email_address"
    NULL AS gender_id, -- Adding the new column "gender_id"
    NULL AS vital_status_id, -- Adding the new column "vital_status_id"
    NULL AS consent_document_name -- Adding the new column "consent_document_name"
FROM
    catissue_coll_prot_reg cpr
JOIN
    catissue_participant p ON cpr.PARTICIPANT_ID = p.IDENTIFIER;
