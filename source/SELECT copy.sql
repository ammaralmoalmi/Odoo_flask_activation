query=""" SELECT 
            x_studio_product_id AS id,
            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s' AND '%s' ) 
                THEN 
                COALESCE(x_studio_meters,0)
                END
            ),0) AS Q1_m,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_kg,0)
                END
            ),0) AS Q1_kg,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_meters,0)
                END
            ),0) AS Q2_m,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_kg,0)
                END
            ),0) AS Q2_kg,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_meters,0)
                END
            ),0) AS Q3_m,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_kg,0)
                END
            ),0) AS Q3_kg,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_meters,0)
                END
            ),0) AS Q4_m,

            COALESCE(sum(
            CASE WHEN
                (x_translated_date  BETWEEN '%s'  AND '%s' ) 
                THEN 
                COALESCE(x_studio_kg,0)
                END
            ),0) AS Q4_kg

FROM 
        x_production_data_record
WHERE
        x_studio_product_id  in %s and x_imported = True and x_studio_active = True and x_studio_type ='record'

GROUP BY x_studio_product_id """ % (
    quarter[0]['start'],
    quarter[0]['end'],
    quarter[1]['start'],
    quarter[1]['end'],
    quarter[2]['start'],
    quarter[2]['end'],
    quarter[3]['start'],
    quarter[3]['end'],
    _ids

)