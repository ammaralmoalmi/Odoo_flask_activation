SELECT 
product_id AS Product,
sum(tbl.cost_Jan) AS cost_Jan,
sum(tbl.qty_Jan) AS qty_Jan,
sum(tbl.Averg_Jan) AS Averg_Jan,
sum(tbl.cost_Fab) AS cost_Fab,
sum(tbl.qty_Fab) AS cost_Fab,
sum(tbl.Averg_Fab) AS Averg_Fab,
sum(tbl.cost_Mar) AS cost_Mar,
sum(tbl.qty_Mar) AS cost_Mar,
sum(tbl.Averg_Mar) AS Averg_Mar,
sum(tbl.cost_Apr) AS cost_Apr,
sum(tbl.qty_Apr) AS cost_Apr,
sum(tbl.Averg_Apr) AS Averg_Apr,
sum(tbl.cost_May) AS cost_May,
sum(tbl.qty_May) AS cost_May,
sum(tbl.Averg_May) AS Averg_May,
sum(tbl.cost_Jun) AS cost_Jun,
sum(tbl.qty_Jun) AS cost_Jun,
sum(tbl.Averg_Jun) AS Averg_Jun,
sum(tbl.cost_Jul) AS cost_Jul,
sum(tbl.qty_Jul) AS cost_Jul,
sum(tbl.Averg_Jul) AS Averg_Jul,
sum(tbl.cost_Aug) AS cost_Aug,
sum(tbl.qty_Aug) AS cost_Aug,
sum(tbl.Averg_Aug) AS Averg_Aug,
sum(tbl.cost_Sep) AS cost_Sep,
sum(tbl.qty_Sep) AS cost_Sep,
sum(tbl.Averg_Sep) AS Averg_Sep,
sum(tbl.cost_Sep) AS cost_Sep,
sum(tbl.qty_Oct) AS cost_Oct,
sum(tbl.Averg_Oct) AS Averg_Oct,
sum(tbl.cost_Nov) AS cost_Nov,
sum(tbl.qty_Nov) AS cost_Nov,
sum(tbl.Averg_Nov) AS Averg_Nov,
sum(tbl.cost_Dec) AS cost_Dec,
sum(tbl.qty_Dec) AS cost_Dec,
sum(tbl.Averg_Dec) AS Averg_Dec

FROM 
( SELECT 
                      product_id AS id,
                        
                        CASE WHEN (extract( month from account_move_line.date) =1 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Jan,
          
                        CASE WHEN (extract( month from account_move_line.date) =1) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Jan,
                        CASE WHEN (extract( month from account_move_line.date) =1) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Jan,


                        CASE WHEN (extract( month from account_move_line.date) =2 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Fab,
          
                        CASE WHEN (extract( month from account_move_line.date) =2) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Fab,
                        CASE WHEN (extract( month from account_move_line.date) =2) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Fab,

                                        CASE WHEN (extract( month from account_move_line.date) =3 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Mar,
          
                        CASE WHEN (extract( month from account_move_line.date) =3) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Mar,
                        CASE WHEN (extract( month from account_move_line.date) =3) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Mar,

                                        CASE WHEN (extract( month from account_move_line.date) =4 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Apr,
          
                        CASE WHEN (extract( month from account_move_line.date) =4) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Apr,
                        CASE WHEN (extract( month from account_move_line.date) =4) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Apr,

                        CASE WHEN (extract( month from account_move_line.date) =5 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_May,
          
                        CASE WHEN (extract( month from account_move_line.date) =5) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_May,
                        CASE WHEN (extract( month from account_move_line.date) =5) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_May,

                                        CASE WHEN (extract( month from account_move_line.date) =6 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Jun,
          
                        CASE WHEN (extract( month from account_move_line.date) =6) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Jun,
                        CASE WHEN (extract( month from account_move_line.date) =6) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Jun ,

                                        CASE WHEN (extract( month from account_move_line.date) =7 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Jul,
          
                        CASE WHEN (extract( month from account_move_line.date) =7) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Jul,
                        CASE WHEN (extract( month from account_move_line.date) =7) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Jul,
                                        CASE WHEN (extract( month from account_move_line.date) =8 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Aug,
          
                        CASE WHEN (extract( month from account_move_line.date) =8) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Aug,
                        CASE WHEN (extract( month from account_move_line.date) =8) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Aug ,

                                        CASE WHEN (extract( month from account_move_line.date) =9 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Sep,
          
                        CASE WHEN (extract( month from account_move_line.date) =9) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Sep,
                        CASE WHEN (extract( month from account_move_line.date) =9) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Sep ,

                                        CASE WHEN (extract( month from account_move_line.date) =10 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Oct,
          
                        CASE WHEN (extract( month from account_move_line.date) =10) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Oct,
                        CASE WHEN (extract( month from account_move_line.date) =10) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Oct ,

                                        CASE WHEN (extract( month from account_move_line.date) =11 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Nov,
          
                        CASE WHEN (extract( month from account_move_line.date) =11) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Nov,
                        CASE WHEN (extract( month from account_move_line.date) =11) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Nov ,

                                        CASE WHEN (extract( month from account_move_line.date) =12 ) THEN 
                                    (sum(
                                    COALESCE(
                                        (quantity * price_unit)
                                        ,0)
                                    ) ) END AS cost_Dec,
          
                        CASE WHEN (extract( month from account_move_line.date) =12) THEN 
                                    (sum(
                                        COALESCE(quantity,0)
                                        )) END AS qty_Dec,
                        CASE WHEN (extract( month from account_move_line.date) =12) THEN 
                                    (round((
                                        (
                                            sum(
                                                COALESCE(
                                            (quantity * price_unit)
                                            ,0)
                                                )   
                                        )/ (
                                            sum(
                                            COALESCE(quantity,0))
                                            )
                                        ),2)) END AS Averg_Dec          
                         
    FROM 
                account_move_line
    WHERE
                parent_state = 'posted'  AND quantity >0 AND  product_id=2156 AND account_id = 698 AND date BETWEEN '2021-01-01' AND '2021-12-31'
    GROUP BY 
                product_id,extract( month from account_move_line.date) 
) as tbl
GROUP BY product_id