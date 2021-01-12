from flask import Flask
from flask_admin import AdminIndexView
from flask_admin.contrib.sqlamodel import ModelView
from extensions import *
from models import *
import config

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = config.DATABASE_FILE
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = '1234567890'
app.config['FLASK_ADMIN_SWATCH'] = 'cerulean'

db.init_app(app)
admin.init_app(app)


class UserModelView(ModelView):
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True
    can_export = True
    create_modal = True


admin.add_view(UserModelView(Users, db.session))


@app.before_first_request
def db_creat():
    db.create_all()


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    app.run()
