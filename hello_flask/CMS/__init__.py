from flask import Flask, render_template, request, url_for, redirect, flash, session
import sqlite3 as sql 
from functools import wraps

app = Flask(__name__)

def connection():
	try:
		con = sql.connect("Stevens.db")
		con.row_factory = sql.Row
		cur = con.cursor()
		return con, cur
	except Exception as e:
		return "leeesh"

# handling errors
@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html")

@app.errorhandler(500)
def method_not_found(e):
    print e
    return render_template("500.html")

def login_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash("You need to login first")
            return redirect(url_for('login'))

    return wrap

@app.route("/logout/")
@login_required
def logout():
    session.clear()
    flash("You have been logged out!")
    return redirect(url_for('login'))

@app.route('/',methods=["GET","POST"])
def login():
    error = ''
    try:
        con, cur = connection()
        if request.method == "POST":

            data = cur.execute("SELECT * FROM Admin WHERE Aemail = '%s'" % request.form['email'])
            
            data = cur.fetchone()[2]

            if request.form['password'] == data:
                session['logged_in'] = True
                session['name'] = "Maha"

                #flash("You are now logged in")
                return redirect(url_for("dashboard"))

            else:
                error = "Invalid credentials, try again."

        return render_template("login.html", error=error)

    except Exception as e:
        #flash(e)
        error = "Invalid credentials, try again."
        return render_template("login.html", error = e)  
		

@app.route('/users/')
@login_required
def users():
	con, cur = connection()
	cur.execute("select * from Users")
	rows = cur.fetchall();
	return render_template("users.html",rows = rows)


@app.route('/events/')
@login_required
def events():
	con, cur = connection()
	cur.execute("select * from Events")
	rows = cur.fetchall();
	return render_template("events.html",rows = rows)

@app.route('/admin/')
@login_required
def admin():
	con, cur = connection()
	cur.execute("select * from Admin")
	rows = cur.fetchall();
	return render_template("admin.html",rows = rows)

@app.route('/category/')
@login_required
def category():
	con, cur = connection()
	cur.execute("select * from Category")   
	rows = cur.fetchall();
	return render_template("category.html",rows = rows)

@app.route('/dashboard/')
@login_required
def dashboard():
    return render_template("dashboard.html")

@app.route('/register/', methods=["GET","POST"])
def register_page():
    try:
        con,cur = connection()
        return("okay")
    except Exception as e:
        return(str(e))

@app.route('/blank-page/')
@login_required
def blankpage():
    return render_template("blank-page.html")

@app.route('/h/')
@login_required
def hpage():
    return render_template("h.html")	



if __name__ == "__main__":
	app.secret_key = '39ie94884ur4yr75yr57py'
	app.run()