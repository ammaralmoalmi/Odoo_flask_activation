from flask import Flask,jsonify,render_template
import socket
import os
import shutil
from datetime import date



# url = "http://172.16.1.250:9069"
# url = "http://172.16.1.250:8069"
url="https://odoo.hongtaifaith.cn"
# db="odoo_community"
# db="Odoo_15"
db= "odoo.hongtaifaith.cn"
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




@app.route("/sabackup")
def sabackup():
   
    
    # API to get all server actions
    server_actions = models.execute_kw(db, uid, password,'ir.actions.server', 'search_read', [[]],{'fields': ['id','name','model_id','code']})
    # pars= [str(par) for par in partners_ids]
    # print(odoo_models)




    ######## create main folder, if exsits remove all content#########
    # _today= 
    _today=date.today().strftime("%b-%d-%Y")
    # "odoo15_server_actions - {_today}"
    directory_name="odoo_server_actions-%s"%_today
    # print(directory_name)
    # directory_path="/app"
    directory_path="/mnt/d/odoo_code"
    # directory_path="/home/alnassaj/sabackup"
    # directory_path="/workspaces/OdooAPI/Odoo_COde"
    _directory_path = os.path.join(directory_path,directory_name)
    if os.path.exists(_directory_path):
        shutil.rmtree(_directory_path)
    os.mkdir(_directory_path)
    # To write to this file 
    # _text = ''' you text which maybe array 
    # of text line ['a','b','c'] 
    # and maybe you need to loop '''
    # if os.path.exists(_directory_path):
    #     # print("yes")
    ###### to create a folder for each module and file for each server action
    for r in server_actions:
        # Folder
        # _folder=
        # some character prevent to create file as it is not allowed in win file name
        # _date=datetime.toda()
        folder_name= str(r['model_id'][1]).replace("/"," ")
        folder_name.replace(":"," ")
        # path where to create
        # _path="/mnt/d/odoo_server_actions"

        # link them to make a full path
        _folder_path = os.path.join(_directory_path,folder_name)

        # print(_folder_path)
        # remove if exsit
        # os.rmdir(_folder_path)
        
        # remove non empty directory with all contant
        if not (os.path.exists(_folder_path)):
            os.mkdir(_folder_path)
        # shutil.rmtree(_folder_path)
        # create the folder
        
        # "w" - open a (new) file to write with w option will delete any previous existing file and create a new file to write.
        # "a" - If you want to append to an existing file, then use open statement with “a” option. In append mode, Python will create the file if it does not exist.
        _name= str(r['name']).replace("/"," ")
        # folder_name= str(r['model_id'][1]).replace("/"," ")
        _name.replace(":"," ")
        _file_name="%s.txt"%_name

        # print(_file_name)
        # print(r)
        _file_path = os.path.join(_folder_path,_file_name)

        if os.path.exists(_file_path):
            os.remove(_file_path)
        _file_open = open(_file_path, "w")
        _text='''
            #################################################
            # Action_name = %s                              # 
            # Action_id= %s                                 #
            # Action_model = %s                             # 
            #################################################
            Python Code
            %s
            '''% (str(r['name']),str(r['id']),str(r['model_id']),str(r['code']))
        _file_open.write(_text)

        # To commit the change and save 

        _file_open.close()
        # for key in r:
        #     # x=key[r]['id']
        #     # print(r)
        # _message = "All server action has been saved %s"%_today
        _message = "All server action has been saved"
        # render_template('user.html',Name=_message)
    return render_template('user.html',_url=url,Name=_message)

# _today=date.today().strftime("%b-%d-%Y")
# directory_name="odoo15_server_actions - %s"%_today
# print(directory_name)
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)
    # sabackup()

