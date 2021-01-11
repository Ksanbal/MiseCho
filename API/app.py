from flask import Flask
from flask_admin import AdminIndexView
from flask_admin.contrib.sqlamodel import ModelView
from extensions import admin, db
# from models import User
import config

app = Flask(__name__)

# DB
app.config['SQLALCHEMY_DATABASE_URI'] = config.DATABASE_FILE    # DB 파일 연결
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# admin
app.config['FLASK_ADMIN_SWATCH'] = 'sandstone'  # 테마 설정
admin.init_app(app)


class UserModelView(ModelView):
    can_create = True
    can_edit = True
    can_delete = True
    can_view_details = True
    can_export = True
    create_modal = True

# admin.add_view(UserModelView(User, db.session))

@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    app.run()
