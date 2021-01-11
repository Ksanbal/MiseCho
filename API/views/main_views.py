from flask import Blueprint

bp = Blueprint('main', __name__, url_prefix='/')


@bp.route('/')
def hello_checkpm():
    return 'Hello, CheckPM!'


@bp.route('/index')
def index():
    return 'CheckPM index'
