from backend.models.mysql_connection_pool import MySQLPool

class AuthorModel:
    def __init__(self):
        self.mysql_pool = MySQLPool()

    def get_author(self, author_id):
        params = {'author_id' : author_id}
        rv = self.mysql_pool.execute("SELECT * from authors where author_id=%(author_id)s", params)
        data = []
        content = {}
        for result in rv:
            content = {'author_id': result[0], 'name': result[1], 'country': result[2], 'date_of_birth': result[3], 'date_of_death': result[4]},
            data.append(content)
            content = {}
        return data

    def get_authors(self):
        rv = self.mysql_pool.execute("SELECT * from authors")
        data = []
        content = {}
        for result in rv:
            content = {'author_id': result[0], 'name': result[1], 'country': result[2], 'date_of_birth': result[3],
                       'date_of_death': result[4]},
            data.append(content)
            content = {}
        return data

    def create_author(self, name, country, date_of_birth, date_of_death):
        data = {
            'name' : name,
            'country' : country,
            'date_of_birth': date_of_birth,
            'date_of_death': date_of_death
        }
        query = """insert into authors (name, country, date_of_birth, date_of_death) 
            values (%(name)s, %(country)s, %(date_of_birth)s, %(date_of_death)s, %(date_of_birth)s)"""
        cursor = self.mysql_pool.execute(query, data, commit=True)

        data['author_id'] = cursor.lastrowid
        return data

    def update_author(self, name, country, date_of_birth, date_of_death):
        data = {
            'name' : name,
            'country' : country,
            'date_of_birth': date_of_birth,
            'date_of_death': date_of_death
        }
        query = """update authors set name = %(name)s, country = %(country)s,
                    date_of_birth= %(date_of_birth)s, date_of_death where author_id = %(author_id)s"""
        cursor = self.mysql_pool.execute(query, data, commit=True)

        result = {'result':1}
        return result

    def delete_author(self, author_id):
        params = {'author_id' : author_id}
        query = """delete from authors where author_id = %(author_id)s"""
        self.mysql_pool.execute(query, params, commit=True)

        result = {'result': 1}
        return result


