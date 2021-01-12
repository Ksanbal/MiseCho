from flask_admin import Admin
from flask_sqlalchemy import SQLAlchemy

admin = Admin(name='Admin : DB Views', template_mode='bootstrap3')
db = SQLAlchemy()