# import 파일 관리
from flask_admin import Admin
from flask_sqlalchemy import SQLAlchemy

admin = Admin(name='CheckPM', template_mode='bootstrap3')

db = SQLAlchemy()