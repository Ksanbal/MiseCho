from extensions import db


class Users(db.Model):
    __table_name__ = 'users'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(100), unique=False, nullable=False)
    c_id = db.Column(db.Integer, db.ForeignKey('companys.id', ondelete='CASCADE'))


class Companys(db.Model):
    __table_name__ = 'companys'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=True)


class Notices(db.Model):
    __table_name__ = 'notices'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    date = db.Column(db.DateTime, unique=False, nullable=False)
    content = db.Column(db.String(100), unique=False, nullable=True)
    d_id = db.Column(db.Integer, db.ForeignKey('devices.id', ondelete='CASCADE'))
    c_id = db.Column(db.Integer, db.ForeignKey('companys.id', ondelete='CASCADE'), nullable=True)


class Devices(db.Model):
    __table_name__ = 'devices'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    connect = db.Column(db.Boolean, nullable=False)
    freq = db.Column(db.Integer, nullable=False, default=5)
    # 0 최고, 1 좋음, 2 양호, 3 보통, 4 나쁨, 5 상당히 나쁨, 6 매우 나쁨, 7 최악
    pmhigh = db.Column(db.Integer, nullable=False, default=4)
    null_freq = db.Column(db.Integer, nullable=False)
    work_s = db.Column(db.String(4), nullable=False)
    work_e = db.Column(db.String(4), nullable=False)
    comment = db.Column(db.String(100), nullable=True)
    c_id = db.Column(db.Integer, db.ForeignKey('companys.id', ondelete='CASCADE'))


class Datas(db.Model):
    __table_name__ = 'datas'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    date = db.Column(db.DateTime, unique=False, nullable=False)
    pm10 = db.Column(db.Integer)
    pm25 = db.Column(db.Integer)
    d_id = db.Column(db.Integer, db.ForeignKey('devices.id', ondelete='CASCADE'))


class AvgDatas(Datas):
    __table_name__ = 'avgdatas'

