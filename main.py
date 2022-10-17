import pandas as pd
import itertools
from config_db import config
from psycopg2 import sql, connect, DatabaseError

df = pd.read_csv('data/netflix.csv');
params = config()

def insert(table_name, columns = [], rows = []):
	conn = None
	try:
		conn = connect(**params)
		conn.autocommit = True
		cur = conn.cursor()

		for values in rows:
			query = sql.SQL("INSERT INTO {table_name} ({columns}) VALUES ({values})").format(
				table_name=sql.Identifier(table_name),
				columns=sql.SQL(', ').join([sql.Identifier(i) for i in columns]),
				values=sql.SQL(', ').join([sql.Literal(i) for i in values])
			)

			print(query.as_string(conn))
			cur.execute(query.as_string(conn))

		cur.close()
	except (Exception, DatabaseError) as error:
		print(error)
	finally:
		if conn is not None:
			conn.close()


memo = {}

def select_by_value(table_name, field, value):
	if value in memo:
		return memo[value]

	conn = None
	try:
		conn = connect(**params)
		conn.autocommit = True
		cur = conn.cursor()

		query = sql.SQL("SELECT id FROM {table_name} WHERE {field} = {value}").format(
			table_name=sql.Identifier(table_name),
			field=sql.Identifier(field),
			value=sql.Literal(value)
		)

		cur.execute(query.as_string(conn))
		res = cur.fetchone()

		if res is None:
			raise Exception (f'Valor não encontrado na tabela "{table_name}" para a coluna "{field}"')

		cur.close()
		
		memo[value] = res[0]
		return res[0]
	except (Exception, DatabaseError) as error:
		print(error)
	finally:
		if conn is not None:
			conn.close()

def main(): 
	types = [[i] for i in df['type'].unique()]
	countries = [[i] for i in df['country'].unique()]
	rates = [[i] for i in df['rating'].unique()]

	directors = pd.DataFrame(df['director'].str.split(',').tolist()).stack().apply(lambda x: x.strip()).unique()
	directors = [[i] for i in directors]

	genres = pd.DataFrame(df['listed_in'].str.split(',').tolist()).stack().apply(lambda x: x.strip()).unique()
	genres = [[i] for i in genres]

	# insert('tb_director', ['name'], directors)
	# insert('tb_genre', ['description'], genres)
	# insert('tb_type', ['description'], types)
	# insert('tb_country', ['name'], countries)
	# insert('tb_rating', ['description'], rates)

	df['type'] = df['type'].apply(lambda x: select_by_value('tb_type', 'description', x))
	df['country'] = df['country'].apply(lambda x: select_by_value('tb_country', 'name', x))
	df['rating'] = df['rating'].apply(lambda x: select_by_value('tb_rating', 'description', x))

	contents = [list(row) for row in df.drop(columns=['listed_in', 'director']).itertuples(index=False)]

	# insert('tb_content', ['show_id', 'type_id', 'title', 'country_id', 'date_added', 'release_year', 'rating_id', 'duration'], contents)

	ids = []
	# print('Inserindo em tb_content_director aguarde...')
	# for directors, show_ids in df[['director', 'show_id']].apply(lambda x: x.str.split(', ').tolist()).itertuples(index=False):
	# 	for director in directors:
	# 		director_id = select_by_value('tb_director', 'name', director)
	# 		content_id = select_by_value('tb_content', 'show_id', show_ids[0])
	# 		ids.append([content_id, director_id])

	# insert('tb_content_director', ['content_id', 'director_id'], ids)

	ids = []
	print('Inserindo em tb_content_genre aguarde...')
	for genres, show_ids in df[['listed_in', 'show_id']].apply(lambda x: x.str.split(', ').tolist()).itertuples(index=False):
		for genre in genres:
			genre_id = select_by_value('tb_genre', 'description', genre)
			content_id = select_by_value('tb_content', 'show_id', show_ids[0])
			ids.append([content_id, genre_id])

	insert('tb_content_genre', ['content_id', 'genre_id'], ids)

if __name__ == '__main__':
    main()
