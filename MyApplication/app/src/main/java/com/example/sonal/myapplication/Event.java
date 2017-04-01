package com.example.sonal.myapplication;

import java.util.Date;

/**
 * Created by sonal on 2/12/2017.
 */

public class Event {
    private String eventName, eventVenue;
    private String eventDate;
    private double eventTime;

    public Event(String eventName,String eventVenue,String eventDate, double eventTime) {
        super();
        this.eventName = eventName;
        this.eventVenue = eventVenue;
        this.eventDate = eventDate;
        this.eventTime = eventTime;
    }

    public String getEventName(){
        return eventName;
    }
    public String getEventVenue(){
        return eventVenue;
    }
    public String getEventDate(){
        return eventDate;
    }
    public double getEventTime(){
        return eventTime;
    }

    // return toString() so that it works out of the box
    @Override
    public String toString() {
        return this.eventName;
    }
}

