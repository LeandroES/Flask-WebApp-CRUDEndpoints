from flask import Blueprint
from flask import jsonify
from flask import request
from flask_cors import CORS, cross_origin
from backend.models.author_model import AuthorModel

model = AuthorModel()


authors_bp = Blueprint('authors_bp', __name__)


@authors_bp.route('/author', methods=['PUT'])
@cross_origin()
def create_author():
    content = model.create_author(request.json['name'], request.json['country'], request.json['date_of_birth'], request.json['date_of_death'])
    return jsonify(content)

@authors_bp.route('/author', methods=['PATCH'])
@cross_origin()
def update_author():
    content = model.update_author(request.json['author_id'], request.json['name'], request.json['country'], request.json['date_of_birth'], request.json['date_of_death'])
    return jsonify(content)

@authors_bp.route('/author', methods=['DELETE'])
@cross_origin()
def delete_author():
    return jsonify(model.delete_author(int(request.json['author_id'])))

@authors_bp.route('/author', methods=['POST'])
@cross_origin()
def author():
    return jsonify(model.get_author(int(request.json['author_id'])))

@authors_bp.route('/authors', methods=['POST'])
@cross_origin()
def authors():
    return jsonify(model.get_authors())