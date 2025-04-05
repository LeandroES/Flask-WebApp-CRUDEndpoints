from flask import Flask
from flask_cors import CORS

from blueprints.authors_bp import authors_bp
from blueprints.books_bp import books_bp


app = Flask(__name__)

app.register_blueprint(authors_bp)
app.register_blueprint(books_bp)

cors = CORS(app)

if __name__ == "__main__":
        app.run(debug=True)