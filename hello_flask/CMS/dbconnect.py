import sqlite3 as sql

def conncetion():
	try:
		con = sql.connect("Stevens.db")
		con.row_factory = sql.Row
		cur = con.cursor()
		rows = cur.fetchall();
		return con, cur, rows
	except Exception as e:
		return "leeesh"
