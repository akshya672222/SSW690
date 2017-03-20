import urllib2
import io
import  re
import sys
from bs4 import BeautifulSoup
import sqlite3

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
            
            # get title
            title= ev.find("h3",attrs={"class" : "events_list_wide_item_title"})
            ti=(title.get_text()).encode('ascii', 'ignore')
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
            temp+=[desc]
            
            links=ev.find("a",attrs={"class" :"events_list_wide_item_button events_list_wide_item_button_detail"})
            l= links.get('href').encode('ascii', 'ignore')
            desclink= D_L + l
            temp+=[desclink]
            
            #fitching the full description of each event
            """
            link= urllib2.Request(desclink,headers={'User-Agent': 'Safari/537.36'})
            h = urllib2.urlopen(link).read().decode('utf8')
            s = BeautifulSoup(h, 'html.parser')
            desc =s.find("div",attrs={"class" : "field-item even"})
            m=(desc.get_text()).encode('ascii', 'ignore')
            print m
            d=(desc.get_text()).encode('ascii', 'ignore')
            temp+=[d]
            """
            # get category
            category = ev.find("span",attrs={"class" : "events_list_wide_item_cat"})
            c=(category.get_text()).encode('ascii', 'ignore')
            if len(c)>0:
                temp+=[c]
            else:
                temp+=["NA"]
        
        Event_List+=[temp]

  
    for r in Event_List:
        print r
    return Event_List
   
 


def fill_db(Event_Data,cur,con):
    for r in Event_Data:
        cur.execute("INSERT INTO Events (Ename, Elocation, Etime, Edate,Edescription,Eimage) VALUES (?,?,?,?,?,?)",(r[1],r[2],r[3],r[0],r[4],r[5]))
        con.commit()
    print "MAHA"


try:
    con = sqlite3.connect("Stevens.db")
    cur=con.cursor()
    
except Exception as e: #sqlite3.OperationalError
    print e

inputURL = "https://www.stevens.edu/events"

url= urllib2.Request(inputURL,headers={'User-Agent': 'Safari/537.36'})

html = urllib2.urlopen(url).read().decode('utf8')
soup = BeautifulSoup(html, 'html.parser')

E =soup.find_all("div",attrs={"class" : "events_list_wide_day"})


Event_Data= fitch_event(E)
print len(Event_Data)
    
fill_db(Event_Data,cur,con)
    
    

