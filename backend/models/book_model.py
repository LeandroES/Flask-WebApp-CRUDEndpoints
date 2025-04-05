from backend.models.mysql_connection_pool import MySQLPool

class BookModel:
    def __init__(self):
        self.mysql_pool = MySQLPool()

    def get_book(self, book_id):
        params = {'book_id' : book_id}
        rv = self.mysql_pool.execute("""SELECT B.book_id, A.name, B.title, B.publication_year, B.genre from books B 
                                        inner join authors A on B.author_id = A.author_id
                                        where B.book_id = %(book_id)s""", params)
        data = []
        content = {}
        for result in rv:
            content = {'book_id': result[0], 'name': result[1], 'title': result[2], 'publication_year': result[3], 'genre': result[4]}
            data.append(content)
            content = {}
        return data

    def get_books(self):
        rv = self.mysql_pool.execute("""SELECT B.book_id, A.name, B.title, B.publication_year, B.genre from books B 
                                        inner join authors A on B.author_id = A.author_id""")
        data = []
        content = {}
        for result in rv:
            content = {'book_id': result[0], 'name': result[1], 'title': result[2], 'publication_year': result[3], 'genre': result[4]}
            data.append(content)
            content = {}
        return data

    def create_book(self, title, publication_year, genre, author_id):
        data = {
            'title' : title,
            'publication_year' : publication_year,
            'genre' : genre,
            'author_id' : author_id
        }
        query = """insert into books (title, publication_year, genre, author_id) 
            values (%(title)s, %(publication_year)s, %(genre)s, %(author_id)s)"""
        cursor = self.mysql_pool.execute(query, data, commit=True)

        data['book_id'] = cursor.lastrowid
        return data

    def delete_book(self, book_id):
        params = {'book_id' : book_id}
        query = """delete from books where book_id = %(book_id)s"""
        self.mysql_pool.execute(query, params, commit=True)

        data = {'result': 1}
        return data

if __name__ == "__main__":
    tm = BookModel()
