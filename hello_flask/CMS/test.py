from flask import Flask, render_template, request
import sqlite3 as sql
app = Flask(__name__)


@app.route('/')
def list():
   con = sql.connect("Stevens.db")
   con.row_factory = sql.Row
   
   cur = con.cursor()
   cur.execute("select * from users")
   
   rows = cur.fetchall();
   return render_template("blank-page.html",rows = rows)

if __name__ == '__main__':
   app.run(debug = True)