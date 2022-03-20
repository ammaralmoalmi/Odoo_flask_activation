# ID: 1884
# NAME: [ALN] Print Packing list to Excel
# MODEL_NAME: x_shipment_booking
# TYPE: server
# TEST_AUTO: 0
# TEST_FUNCTION: testing
# REFRESH: NO
# REF: aln_shipment_print
# IMPORTS: render.py

# Build Values
def genValues(pl):

    # Table about details
    lines = []
    index = 0
    for r in pl.x_record_ids:
        index+=1

        soline = r.x_sale_order_line_id
        # soline = env['sale.order.line'].browse(14484)
        customerColor = soline.x_customer_color_id

        product = r.x_studio_product_id
        productTemplate = product.product_tmpl_id
        materialNumber = productTemplate.x_barcode_material or ""
        materialName = ""
        materialColor = ""
        # alert(materialNumber)
        
        if customerColor:
            materialName = customerColor.x_studio_code or ""
        
        if len(materialName) > 0 and "-" in materialName:
            parts = materialName.split('-')
            materialColor = parts[len(parts)- 1]
            materialName = materialName.replace("-" + materialColor,"")

        row = {
            "number": str(index),
            "material_number": materialNumber,
            "material_name": materialName,
            "color": materialColor,
            "quantity": r.x_studio_meters,
            "barcode": r.x_customer_barcode,
            "order": r.x_sale_order_id.name,
            "lot": r.x_studio_product_lot_ref or "",
            "roll_number": r.x_roll_sequence,
            "weight": r.x_studio_kg,
            "type": materialName,
            "unit_price": soline.price_unit or 0.0
        }
        lines.append(row)
    # alert(lines)

    # Table about value
    valueLines = []
    valueDict = {}
    shipmentValue_rolls = 0
    shipmentValue_quantity = 0
    shipmentValue_total = 0
    shipmentValue_freight = pl.x_freight_cost or 0.0
    shipmentValue_grandTotal = 0
    shipmentValue_rolls = 0

    for l in lines:
        if l['type'] not in valueDict:
            valueDict[l['type']] = {
                "type": l['type'],
                "rolls": 0,
                "qty": 0.0,
                "unit_price": l['unit_price'],
                "total": 0.0
            }
        valueDict[l['type']]['rolls'] += 1
        shipmentValue_rolls += 1
        
        valueDict[l['type']]['qty'] += l['quantity']
        shipmentValue_quantity += l['quantity']

        valueDict[l['type']]['total'] += l['quantity'] * l['unit_price']
        shipmentValue_total +=  l['quantity'] * l['unit_price']

    shipmentValue_grandTotal = shipmentValue_total + shipmentValue_freight
    
    for k in valueDict:
        valueLines.append(valueDict[k])

    values = {
        "values": [
            {
                "sheetNumber": 1,
                "placeholders": {
                    "lines": lines,
                    "containers": ", ".join([p.x_name for p in pl.x_packing_ids]),
                    "seals": ", ".join([p.x_name for p in pl.x_packing_ids]),
                    "fields": getFieldValues(record)
                }
            },
            {
                "sheetNumber": 2,
                "placeholders": {
                    "valueLines": valueLines,
                    "shipmentValue_rolls": shipmentValue_rolls,
                    "shipmentValue_quantity": shipmentValue_quantity,
                    "shipmentValue_total": shipmentValue_total,
                    "shipmentValue_freight": shipmentValue_freight,
                    "shipmentValue_grandTotal": shipmentValue_grandTotal
                }
            }
        ],
        "filename": "%s.xlsx" % (pl.x_name.replace('/', '')),
        "pdfFilename": "%s.pdf" % (pl.x_name.replace('/', ''))
    }
    return values

# if not record:
#     record = env['x_production_data_record'].browse(409)

if 'template' not in env.context:
    env.context['template'] = 'PACKING_LIST/TEMPLATE_PACKING_ALN_UKRAINE.xlsx'

if 'pdf' not in env.context:
    env.context['pdf'] = False

# if env.uid == 2:
#     record = env['x_shipment_booking'].browse(59)
#     # env['context']['template'] = 'PACKING_LIST/TEMPLATE_PACKING_ALN_UKRAINE.xlsx'

if record:
    if 'template' in env.context:
        values = genValues(record)
        outputFormat = {
            "ignorePrintArea": False,
            "orientation": "portrait",
            "fitToWidth": 0,
            "fitToHeight": 0,
            "scale": 100,
            "headings": False,
            "gridLines": False
        }

        pdf = env.context['pdf']
        action = generateAttachment(values,env.context['template'],pdf=pdf,outputFormat=outputFormat)

# OLD
# "images": images,
# "barcode": formatBarcode(pl.x_name,barcodeType='barcode',width=200,opts=barcodeOpts),
# "qrcode": formatBarcode(pl.x_name,barcodeType='qrcode',width=80,opts=smallQrOpts),
# "appcode": formatBarcode("https://record.hongtaifaith.cn/s?q=%s" % pl.x_name,barcodeType='qrcode',width=90,opts=largeQrOpts),
# "company": comp,
# "pageSize": {
#     "width": "80mm",
#     "height": "150mm"
# },
# "margins": {
#     "left": "0mm",
#     "right": "0mm",
#     "top": "0mm",
#     "bottom": "0mm"
# }
# comp = formatCompany(env.company)

# Example for images
# images = []
# for line in pl.x_studio_attachments_ids:
#     images.append({
#         "name": line.x_studio_remarks,
#         "pic1": formatImage(line.x_studio_image_1),
#         "pic2": formatImage(line.x_studio_image_2),
#         "pic3": formatImage(line.x_studio_image_3),
#         "pic4": formatImage(line.x_studio_image_4)
#     })

# Example for lines
# lines = []
# for line in pl.x_studio_line_ids: 
#     l = getFieldValues(line,{
#         "unit": "PCS"
#     }) 
#     # l['hs_code'] = line.x_studio_sales_order_line_id.x_studio_hs_code.code
#     l['price'] = line.x_studio_sales_order_line_id.price_unit
#     l['total'] = (line.x_studio_sales_order_line_id.price_unit or 0.0) * (line.x_studio_quantity or 0.0)
#     lines.append(l)

# Main values
# barcodeOpts = {
#     "bcid": 'code128',  
#     "scale": 3,
#     "height": 6,
#     "includetext": False, 
#     "textxalign": 'left',
# }
# smallQrOpts = {
#     "errorCorrectionLevel": 'Q',
#     "type": 'image/png',
#     # quality: 0.3,
#     "margin": 0,
#     "width": 600,
#     "color": {
#         "dark": "#000000",
#         "light": "#FFFFFF"
#     }
# }
# largeQrOpts = {
#     "errorCorrectionLevel": 'Q',
#     "type": 'image/png',
#     # quality: 0.3,
#     "margin": 0,
#     "width": 600,
#     "color": {
#         "dark": "#000000",
#         "light": "#FFFFFF"
#     }
# }