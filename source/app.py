from flask import Flask,jsonify,render_template
from datetime import datetime , timedelta
import socket
import os
import shutil
from datetime import date



url = "http://0.0.0.0:9069/"
# url = "http://0.0.0.0:9069/"
# url="https://odoo.hongtaifaith.cn"
# db="odoo_community"
# db="Odoo_15"
# db= "odoo.hongtaifaith.cn"
db ="odoo"
username='almoalmi@alnassaj.com'
password='346488'
import xmlrpc.client
common = xmlrpc.client.ServerProxy('{}/xmlrpc/2/common'.format(url))
uid = common.authenticate(db,username,password,{})
version = common.version()

models = xmlrpc.client.ServerProxy('{}/xmlrpc/2/object'.format(url))
# import xmlrpc.client

#############################################################################
#############################################################################



app = Flask(__name__)

@app.route("/fetchdetails")
def fetchdetails():
    Host= socket.gethostname()
    IP= socket.gethostbyname(Host)
    print("Hostname: ",Host)
    print("IP :",IP)
    return str(Host),str(IP)


@app.route("/")
def hello_world():
    return "<p> Hello, Alnassaj!</p>"

# @app.route("/health")
# def health():
#     return jsonify(
#         status="UP"
#     )

@app.route("/web")
def web():
    host,ip = fetchdetails()
    return render_template('hello.html',HostName=host, IPaddress=ip)
@app.route("/web1")
def web1():
    users_ids = models.execute_kw(db, uid, password,'res.users', 'search', [[]],{'limit': 200})
    users = models.execute_kw(db, uid, password,'res.users', 'read', [users_ids], {'fields': ['id','name']})
    _users= [str(par) for par in users]
    # for u in _users:
    #     _id = u['id']
    #     _name=u['name']

    return render_template('user.html',Name=_users)

@app.route("/user")
def user():
   users_ids = models.execute_kw(db, uid, password,'res.users', 'search', [[]],{'limit': 200})
   users = models.execute_kw(db, uid, password,'res.users', 'read', [users_ids], {'fields': ['id','name']})
   _users= [str(par) for par in users]
   Jsn="\n".join(_users)
   print("parnters = ","\n".join(_users)) 
   return jsonify(_users)

@app.route("/partner")
def partner():
   partners_ids = models.execute_kw(db, uid, password,'res.partner', 'search', [[]],{'limit': 200})
   parnters = models.execute_kw(db, uid, password,'res.partner', 'read', [partners_ids], {'fields': ['id','name']})
   pars= [str(par) for par in parnters]
   Jsn="\n".join(pars)
   print("parnters = ","\n".join(pars)) 
   return jsonify(pars)




@app.route("/active")
def active():
   
    _string = '''
# HOW TO
# - Become SuperUser
# - Go to scheduled action
# - Create new action, 
#   model = sytem parameters,
#   execute every 1 day
#   make sure it is active
#   set next execution date to tomorrow early morning (3AM for example) => it will kill all sessions when it changes the expiration, this only happens every 30 days or so
#   number of calls = -1
#   priority 1
#   Execute python code
def alert(s):
  raise UserError(str(s))
  
def disableOdooCron():
  # Disable cron odoo notify
  OdooNotifyCron = env['ir.cron'].search([('name','=','Users: Notify About Unregistered Users')])
  # alert(OdooNotifyCron)
  if OdooNotifyCron.active:
    OdooNotifyCron.write({
      'active': False
    })

def unlockDatabase(index):
  if(index > 2):
    return False
  
  maxAllowedDays = 32
  # alert(index)
  disableOdooCron()
  
  params = [ 
    'database.unlock',
    'database.create_date',
    'database.expiration_date',
    'database.expiration_reason',
    'database.secret',
    'database.uuid'
  ]
  # alert(params)
  r = {}
  
  for p in params:
    pObj = env['ir.config_parameter'].search([('key','=',p)])
    if(len(pObj) > 0 ):
      obj = pObj[0]
      r[obj.key] = obj
  
  dateFormat = "%Y-%m-%d %H:%M:%S"
  
#if 'database.unlock' not in r:
#    r['database.unlock'] = env['ir.config_parameter'].create({
#      'key': 'database.unlock',
#      'value': 'init'
#})
#    unlockDatabase(index+1)
#    return True
  
  now = datetime.datetime.now()
  create_date = datetime.datetime.strptime(r['database.create_date'].value, dateFormat)
  expiration_date = datetime.datetime.strptime(r['database.expiration_date'].value, dateFormat)
  
  expiresIn = expiration_date - now
  mustUnlock = False
  if expiresIn.days<maxAllowedDays:
   new_expiration_date = now + datetime.timedelta(days=maxAllowedDays + 1)
   new_create_date = now
   new_uuid = r['database.secret'].value[:-8] + now.strftime("%d%f")
   new_secret = r['database.uuid'].value[:-9] +  "1" + now.strftime("%d%f")
   mustUnlock = True
  
  if r['database.unlock']:
    if mustUnlock:
      r['database.unlock'].write({
        'value': str(expiration_date.strftime(dateFormat))  + " (expiration) / " +str(now.strftime(dateFormat)) + " (now) / " + str(expiresIn.days)+ " / ==> " + str(new_expiration_date.strftime(dateFormat)) 

      })
      
      r['database.secret'].write({
        'value': new_secret
      })
      r['database.uuid'].write({
        'value': new_uuid
      })
      r['database.create_date'].write({
        'value': new_create_date.strftime(dateFormat)
      })
      r['database.expiration_date'].write({
        'value': new_expiration_date.strftime(dateFormat)
      })
      if 'database.expiration_reason' in r:
        r['database.expiration_reason'].unlink()
      
unlockDatabase(1)
'''

## search if there is a system parameters and delete it.
    expiration_date = models.execute_kw(db, uid, password,'ir.config_parameter','search',[[('key','=','database.expiration_date')]])
    models.execute_kw(db, uid, password,'ir.config_parameter','unlink',[expiration_date])
    unlock_date = models.execute_kw(db, uid, password,'ir.config_parameter','search',[[('key','=','database.unlock')]])
    models.execute_kw(db, uid, password,'ir.config_parameter','unlink',[unlock_date])

    ## search if there is an server action for activation and delete it. 
    server_action = models.execute_kw(db, uid, password,'ir.actions.server','search',[[('name','=','odoo activation')]])
    models.execute_kw(db, uid, password,'ir.actions.server','unlink',[server_action])

## now you can create the parameters in system parameters, you need to calculate the expiration day based on creation day
    database_creation_date = models.execute_kw(db, uid, password,'ir.config_parameter','search_read',[[('key','=','database.create_date')]],{'fields': ['value']})
    database_expiration_date = datetime.strptime(database_creation_date[0]['value'],'%Y-%m-%d %H:%M:%S') + timedelta( days = 29)
    databaseUnlock = str(database_expiration_date - timedelta(days = 1) ) + "(expiration) /" + str(database_creation_date[0]['value']) + "(now)  / 29 / ==>" + str(database_expiration_date)

    expiration_date = models.execute_kw(db, uid, password,'ir.config_parameter','create',[
            {
            'key': 'database.expiration_date',
            'value': str(database_expiration_date)
            }
        ])
    unlock_date = models.execute_kw(db, uid, password,'ir.config_parameter','create',[
            {
            'key': 'database.unlock',
            'value': str(databaseUnlock)
            }
        ])
    
## now you can create the server action.
 
    server_action =  models.execute_kw(db, uid, password,'ir.actions.server','create', [
        {
        'binding_type': "action",
        'model_id': 23,
        'name': 'odoo activation',
        'state': 'code',
        'usage': 'ir_actions_server',
        'code': _string
        }
        ])

## now you can run the server action
    models.execute_kw(db, uid, password,'ir.actions.server','run', [server_action])   


  

    ## delete if you found
    # if len(expiration) > 0 :

    # # record_id = models.execute_kw(db, uid, password,'ir.config_parameter','search',[[('key','=','database.expiration_date')]])
    # # record_id = models.execute_kw(db, uid, password,'ir.config_parameter','search',[[('key','=','database.expiration_date')]])
    # if len(expiration) > 0 :
    #     expiration_date = models.execute_kw(db, uid, password,'ir.config_parameter','write',[expiration,{'value': str(database_expiration_date)}])
    # else:
    
    # pars= [str(par) for par in database_creation_date]
    # pars= [str(par) for par in partners_ids]
    # print(odoo_models) datetime.strptime(database_creation_date[0]['value'],'%b %d %Y %I:%M%p') 
    

    _message = "SERVER ACTION HAS BEEN CREATED %s"%databaseUnlock
## now you can delete the server action and system parameters to hide.
    models.execute_kw(db, uid, password,'ir.config_parameter','unlink',[expiration_date])
    models.execute_kw(db, uid, password,'ir.config_parameter','unlink',[unlock_date])
    models.execute_kw(db, uid, password,'ir.actions.server','unlink',[server_action])
        # render_template('user.html',Name=_message)
    return render_template('user.html',_url=url,Name=_message)

# _today=date.today().strftime("%b-%d-%Y")
# directory_name="odoo15_server_actions - %s"%_today
# print(directory_name)
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5005)
    # sabackup()

