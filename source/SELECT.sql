SELECT
    CAST("ORDER_DATE" as Date) AS "Date",
    "ORDER" AS "Order",
    -- "CUSTOMER" AS "Customer",
    "PRODUCT" AS "Product",
    "DESIGN" As "Design",
    "COLOR" AS "Color",
    "PRICE_TOTAL" AS "Total Price",
    "PLACE_QTY" AS "Place Qty",
    "DELIVERED_QTY" AS "Delivered Qty",
    "INVOICED_QTY" AS "Invoiced Qty",
    "COMPLETION_RATE" AS "Completion",
    "METERS" AS "In Store",
    "PLACE_QTY" - "METERS" As "UnderProduction",
    "DYING_QTY" AS "Dyeing",
    "WEAVING_PRODUCED_QTY" AS "Weaving",
    "PRINTED_PRODUCED_QTY" AS "Printing",
    "BONDING_PRODUCED_QTY" AS "Bonding",
    "BRONZING_PRODUCED_QTY" AS "Bronzing",
    "EMBOSS_PRODUCED_QTY" AS "Emboss",
    "DRY_PRODUCED_QTY" AS "Drying",
    "FINISHING_PRODUCED_QTY" AS "Finishing"
    
FROM
    (
        SELECT
            (
                CAST(
                    (
                        "METERS" + sale_order_line.qty_delivered
                    ) AS float
                ) / CASE
                    WHEN sale_order_line.product_uom_qty = 0 THEN NULL
                    ELSE sale_order_line.product_uom_qty
                END
            ) AS "COMPLETION_RATE",
            "SALE_ORDER_LINE_ID" AS "SALE_ORDER_LINE_ID",
            "WEAVING_PRODUCED_QTY" AS "WEAVING_PRODUCED_QTY",
            "BRONZING_PRODUCED_QTY" AS "BRONZING_PRODUCED_QTY",
            "PRINTED_PRODUCED_QTY" AS "PRINTED_PRODUCED_QTY",
            "BONDING_PRODUCED_QTY" AS "BONDING_PRODUCED_QTY",
            "EMBOSS_PRODUCED_QTY" AS "EMBOSS_PRODUCED_QTY",
            "FINISHING_PRODUCED_QTY" AS "FINISHING_PRODUCED_QTY",
            "DRY_PRODUCED_QTY" AS "DRY_PRODUCED_QTY",
            "DYING_QTY" AS "DYING_QTY",
            "METERS" AS "METERS",
            product_template.name AS "DESIGN",
            CASE
                WHEN product_attribute_value.name IS NOT NULL THEN product_attribute_value.name
                ELSE ''
            END AS "MASTER_COLOR",
            concat(
                '[',
                product_product.default_code,
                '] ',
                product_template.name,
                ' (',
                CASE
                    WHEN product_attribute_value.name IS NOT NULL THEN product_attribute_value.name
                    ELSE ''
                END,
                ')'
            ) AS "PRODUCT",
            sale_order_line.name AS "COLOR",
            sale_order_line.price_total AS "PRICE_TOTAL",
            sale_order_line.product_uom_qty AS "PLACE_QTY",
            sale_order_line.qty_delivered AS "DELIVERED_QTY",
            sale_order_line.qty_invoiced AS "INVOICED_QTY",
            sale_order.name AS "ORDER",
            sale_order.date_order AS "ORDER_DATE",
            substring(
                sale_order.name
                from
                    1 for 4
            ) AS "CUSTOMER"
        FROM
            (
                SELECT
                    "SALE_ORDER_LINE_ID" AS "SALE_ORDER_LINE_ID",
                    sum("WEAVING_PRODUCED_QTY") AS "WEAVING_PRODUCED_QTY",
                    sum("BRONZING_PRODUCED_QTY") AS "BRONZING_PRODUCED_QTY",
                    sum("PRINTED_PRODUCED_QTY") AS "PRINTED_PRODUCED_QTY",
                    sum("BONDING_PRODUCED_QTY") AS "BONDING_PRODUCED_QTY",
                    sum("EMBOSS_PRODUCED_QTY") AS "EMBOSS_PRODUCED_QTY",
                    sum("FINISHING_PRODUCED_QTY") AS "FINISHING_PRODUCED_QTY",
                    sum("DRY_PRODUCED_QTY") AS "DRY_PRODUCED_QTY",
                    sum("DYING_QTY") AS "DYING_QTY",
                    sum("METERS") AS "METERS"
                FROM
                    (
                        (
                            SELECT
                                x_sale_order_line_id AS "SALE_ORDER_LINE_ID",
                                -- "" AS "DATE",
                                0 AS "WEAVING_PRODUCED_QTY",
                                0 AS "BRONZING_PRODUCED_QTY",
                                0 AS "PRINTED_PRODUCED_QTY",
                                0 AS "BONDING_PRODUCED_QTY",
                                0 AS "EMBOSS_PRODUCED_QTY",
                                0 AS "FINISHING_PRODUCED_QTY",
                                0 AS "DRY_PRODUCED_QTY",
                                0 AS "DYING_QTY",
                                x_studio_meters AS "METERS"
                            FROM
                                x_production_data_record
                                -- FULL OUTER JOIN sale_order_line ON sale_order_line.id =  x_production_data_record.x_sale_order_line_id
                            WHERE
                                x_sale_order_line_id IS NOT NULL
                                AND x_imported = TRUE
                                AND x_studio_type = 'record'
                                AND x_location_id IN (8, NULL)
                                AND (
                                    x_studio_routing = 'packing'
                                    OR x_studio_routing = 'cuttingedge'
                                )
                        )
                        
                        UNION
                        (
                            SELECT
                                x_studio_sales_order_line_id AS "SALE_ORDER_LINE_ID",
                                -- "" AS "DATE",
                                (
                                    CASE
                                        WHEN routing_id = 69 THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "WEAVING_PRODUCED_QTY",
                                (
                                    CASE
                                        WHEN routing_id = 185 THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "BRONZING_PRODUCED_QTY",
                                (
                                    CASE
                                        WHEN routing_id = 175 THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "PRINTED_PRODUCED_QTY",
                                (
                                    CASE
                                        WHEN routing_id = 164 THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "BONDING_PRODUCED_QTY",
                                (
                                    CASE
                                        WHEN routing_id = 186 THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "EMBOSS_PRODUCED_QTY",
                                (
                                    CASE
                                        WHEN routing_id = 165 THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "FINISHING_PRODUCED_QTY",
                                (
                                    CASE
                                        WHEN routing_id IN (196, 197) THEN x_studio_quantity_produced
                                        ELSE 0
                                    END
                                ) AS "DRY_PRODUCED_QTY",
                                0 AS "DYING_QTY",
                                0 AS "METERS"
                            FROM
                                mrp_production
                            WHERE
                                x_studio_sales_order_line_id IS NOT NULL
                                AND state NOT IN ('draft', 'cancel')
                        )
                        UNION
                        (
                            SELECT
                                x_studio_sales_order_line_id AS "SALE_ORDER_LINE_ID",
                                -- "" AS "DATE",
                                0 AS "WEAVING_PRODUCED_QTY",
                                0 AS "BRONZING_PRODUCED_QTY",
                                0 AS "PRINTED_PRODUCED_QTY",
                                0 AS "BONDING_PRODUCED_QTY",
                                0 AS "EMBOSS_PRODUCED_QTY",
                                0 AS "FINISHING_PRODUCED_QTY",
                                0 AS "DRY_PRODUCED_QTY",
                                qty_received AS "DYING_QTY",
                                0 AS "METERS"
                            FROM
                                purchase_order_line
                                LEFT JOIN purchase_order ON purchase_order.id = purchase_order_line.order_id
                            WHERE
                                x_studio_sales_order_line_id IS NOT NULL
                                AND purchase_order_line.state IN ('purchase', 'done')
                                AND purchase_order_line.x_studio_product_category = 263
                                -- [[AND {{DATE}}]]
                        )
                    ) "raw"
                GROUP BY
                    "SALE_ORDER_LINE_ID"
                ORDER BY
                    "SALE_ORDER_LINE_ID" ASC
            ) "aggregated"
            LEFT JOIN sale_order_line ON "SALE_ORDER_LINE_ID" = sale_order_line.id
            LEFT JOIN sale_order ON sale_order_line.order_id = sale_order.id
            LEFT JOIN product_product ON sale_order_line.product_id = product_product.id
            LEFT JOIN product_template ON product_product.product_tmpl_id = product_template.id
            LEFT JOIN product_attribute_value ON product_product.x_studio_color = product_attribute_value.id
        WHERE 
            sale_order.x_closed IN (NULL,FALSE)
            AND sale_order.x_studio_order_type IN ('Standard Order')
    ) "consolidated"
WHERE
    1 = 1 
    -- AND "PLACE_QTY" - "METERS" > 0
    
    [[AND "CUSTOMER" = {{CUSTOMER}}]]
    [[AND "ORDER" LIKE CONCAT('%',{{ORDER}},'%')]]
    [[AND "PRODUCT" = {{PRODUCT}}]]
    [[AND "DESIGN" = {{Design}}]]
    [[AND "METERS" > {{INSTORE}} ]]
    [[AND "COLOR" ~ {{COLOR}}]]
    -- [[AND "PLACE_QTY" - "METERS" > {{0}}]]
    
    -- [[AND "Date" = {{DATE}}]]
ORDER BY
    "COMPLETION_RATE" DESC