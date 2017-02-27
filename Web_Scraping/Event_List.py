import urllib2
import io
import  re
import sys
from bs4 import BeautifulSoup

inputURL = "https://www.stevens.edu/events"

url= urllib2.Request(inputURL,headers={'User-Agent': 'Safari/537.36'})

html = urllib2.urlopen(url).read().decode('utf8')
soup = BeautifulSoup(html, 'html.parser')

Event =soup.find_all("article",attrs={"class" : "clearfix events_list_wide_item"})

DL= "https://www.stevens.edu"

Event_List = []

for event in Event:
    temp=[]
    if event.get("class")[0] == u'clearfix':  
        # get date
        time = event.find("time",attrs={"class" : "events_list_wide_item_time"})
        t=(time.get_text()).encode('ascii', 'ignore')
        temp+=[t]
        
        # get category
        category = event.find("span",attrs={"class" : "events_list_wide_item_cat"})
        c=(category.get_text()).encode('ascii', 'ignore')
        if len(c)>0:
            temp+=[c]
        else:
            temp+=["NA"]
        # get title
        title= event.find("h3",attrs={"class" : "events_list_wide_item_title"})
        ti=(title.get_text()).encode('ascii', 'ignore')
        temp+=[ti]
        
        
        """
        links=event.find("a",attrs={"class" :"events_list_wide_item_button events_list_wide_item_button_detail"})
        l= links.get('href')
        desclink= DL + l

        link= urllib2.Request(desclink,headers={'User-Agent': 'Safari/537.36'})

        h = urllib2.urlopen(link).read().decode('utf8')
        s = BeautifulSoup(h, 'html.parser')

        desc =s.find("div",attrs={"class" : "field-item even"})
        m=(desc.get_text()).encode('ascii', 'ignore')

        print m
        
        d=(desc.get_text()).encode('ascii', 'ignore')
        temp+=[d]
        """
        # get location
        Location=event.find("div",attrs={"class" : "fs-cell fs-md-2 fs-lg-4 events_list_wide_item_locations"})

        if len(Location) < 5:
            temp+=["NA"]  
        else:
            m=event.find("div",attrs={"class" : "events_list_wide_item_location_data"})
            loc=(m.get_text()).encode('ascii', 'ignore')
            temp+=[loc]

    Event_List=Event_List+[temp]

print Event_List