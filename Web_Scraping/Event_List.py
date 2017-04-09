import urllib2
import io
import  re
import sys
from bs4 import BeautifulSoup
import sqlite3
from selenium import webdriver
import time

def open_page(url):
    try:
        browser = webdriver.PhantomJS('/Users/rafifarab/Desktop/SSW690/Web_Scraping/phantomjs-2.1.1-macosx/bin/phantomjs')
        browser.get(url)
        html = browser.page_source
        soup = BeautifulSoup ( html , 'html.parser' )
        event = soup.find("div", attrs={"class":"field field-name-body field-type-text-with-summary field-label-hidden"})
        browser.quit()
        return event
    except Exception as e:
        return  e 
        
def fitch_event(Event):
    Event_List = []
    D_L= "https://www.stevens.edu"
    
    for e in Event:
        temp=[]
        
        # get all events under this date
        event =e.find_all("article",attrs={"class" : "clearfix events_list_wide_item"})
        
        for ev in event:
            if len(temp) > 0:
                Event_List+=[temp]
                temp=[]
                
            # get date
            Date = e.find("h2",attrs={"class" : "events_list_day_date"})
            d=(Date.get_text()).encode('ascii', 'ignore')
            temp += [d]
            
            # get title,id
            title= ev.find("h3",attrs={"class" : "events_list_wide_item_title"})
            ti=(title.get_text()).encode('ascii', 'ignore')
            ID= (title.get('id').encode('ascii', 'ignore')).replace("event-title-","")
            temp+=[ID]
            temp+=[ti]

            # get location
            Location=ev.find("div",attrs={"class" : "fs-cell fs-md-2 fs-lg-4 events_list_wide_item_locations"})
            if len(Location) < 5:
                temp+=["NA"]
            else:
                m=ev.find("div",attrs={"class" : "events_list_wide_item_location_data"})
                loc=(m.get_text()).encode('ascii', 'ignore')
                temp+=[loc]
            
            # get time
            time = ev.find("time",attrs={"class" : "events_list_wide_item_time"})
            t=(time.get_text()).encode('ascii', 'ignore')
            temp+=[t]

            # get description
            
            description = ev.find("div",attrs={"class" : "events_list_wide_item_description"})
            desc=((description.get_text()).encode('ascii', 'ignore')).replace("\n","")
            
            
            
            links=ev.find("a",attrs={"class" :"events_list_wide_item_button events_list_wide_item_button_detail"})
            l= links.get('href').encode('ascii', 'ignore')
            desclink= D_L + l
            temp+=[desc] + [desclink]
            """
            desc= open_page(desclink)
            temp+=[desc]
            """
            #fitching the full description of each event

            """
            link= urllib2.Request(desclink,headers={'User-Agent': 'Safari/537.36'})
            h = urllib2.urlopen(link).read().decode('utf8')
            s = BeautifulSoup(h, 'html.parser')
            desc =s.find("div",attrs={"class" : "field-item even"})
            d=(desc.get_text()).encode('ascii', 'ignore')
            temp+=[d]
            """
            # get category
            category = ev.find("span",attrs={"class" : "events_list_wide_item_cat"})
            c=((category.get_text()).encode('ascii', 'ignore')).replace(", ",",")
            if len(c)>0:
                temp+=[c]
            else:
                temp+=["NA"]
        
        Event_List+=[temp]
        
    return Event_List
   
def fitch_category(C):
    te=[]
    categ=[]
    for u in C:
        for option in u.find_all('option'):
            if len(te)>0:
                categ+=[te]
            catId= (option.get('value').encode('ascii', 'ignore')).replace("/events/?category=","")
            catName= (option.get_text()).encode('ascii', 'ignore')
            te=[catId] + [catName]
    
    categ+=[te]
    return categ 

def fitch_event_category(E,C):
    Event_Category=[]
    temp=[]
    
    for r in E: 
        for i in r[7].split(','):  
            for c in C:
                if len(temp) >0:
                   Event_Category+= [temp]
                   temp=[]  
                    
                if i == c[1]:
                    temp= [r[1]]+ [c[0]]
                
    Event_Category+= [temp]
    
    return Event_Category


def fill_db_Event(Event_Data,cur,con):
    for r in Event_Data:
        cur.execute("INSERT OR IGNORE INTO Events (Eid, Ename, Elocation, Etime, Edate, Edescription, Edlink) VALUES (?,?,?,?,?,?,?)",(r[1],r[2],r[3],r[4],r[0],r[5],r[6]))
        con.commit()
    fill_db_timeStamp("Events",cur,con)
    
def delete_db_Event(cur,con):
    cur.execute("DELETE FROM Events WHERE (Edate < date('now','-1 day'))")
    #cur.execute("DELETE FROM Events WHERE (Edate < GETDATE()-1)")
    con.commit()
    fill_db_timeStamp("Events",cur,con)
    
def fill_db_Category(Category_Data,cur,con):
    for r in Category_Data:
        cur.execute("INSERT OR IGNORE INTO Category (Cid, Cname) VALUES (?,?)",(r[0],r[1]))
        con.commit()
    fill_db_timeStamp("Category",cur,con)
    print "MAHA"
    


def fill_db_Event_Category(Event_Category_Data,cur,con):
    for r in Event_Category_Data:
        cur.execute("INSERT OR IGNORE INTO EventCategory (Eid,Cid) VALUES (?,?)",(r[0],r[1]))
        con.commit() 
    fill_db_timeStamp("EventCategory",cur,con)
    print "MAHA"
    

def fill_db_timeStamp(TableName,cur,con):
        cur.execute("INSERT OR IGNORE INTO timestamp (TableName, TimeStamp) VALUES (?,?)",(TableName,int(time.time())))
        con.commit()  

try:
    con = sqlite3.connect("Stevens.db")
    cur=con.cursor()
    
except Exception as e: #sqlite3.OperationalError
    print e

inputURL = "https://www.stevens.edu/events"

url= urllib2.Request(inputURL,headers={'User-Agent': 'Safari/537.36'})
try:

    html = urllib2.urlopen(url).read().decode('utf8')
    soup = BeautifulSoup(html, 'html.parser')
    
    E =soup.find_all("div",attrs={"class" : "events_list_wide_day"})
    C= soup.find_all("select",attrs={"id" : "filter_category"})
      
    
    Event_Data= fitch_event(E)
    Category_Data= fitch_category(C)
    Event_Category_Data= fitch_event_category(Event_Data,Category_Data)
    print len(Event_Data)

    
except Exception as e:
    print e   

    
#fill_db_Event(Event_Data,cur,con)
#fill_db_Category(Category_Data,cur,con)
#fill_db_Event_Category(Event_Category_Data,cur,con)
#delete_db_Event(cur,con)