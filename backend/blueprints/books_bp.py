from flask import Flask
from flask import Blueprint
from flask import request
from flask import jsonify
from werkzeug.utils import secure_filename
import json
from flask_cors import CORS, cross_origin

from backend.models.book_model import BookModel
model = BookModel()

books_bp = Blueprint('books_bp', __name__)

@books_bp.route('/book', methods=['PUT'])
@cross_origin()
def create_book():
    content = model.create_book(request.json['title'], request.json['publication_year'], request.json['genre'], request.json['author_id'])
    return jsonify(content)

@books_bp.route('/book', methods=['DELETE'])
@cross_origin()
def delete_book():
    return jsonify(model.delete_book(int(request.json['book_id'])))

@books_bp.route('/book', methods=['POST'])
@cross_origin()
def book():
    return jsonify(model.get_book(int(request.json['book_id'])))

@books_bp.route('/books', methods=['POST'])
@cross_origin()
def books():
    return jsonify(model.get_books())