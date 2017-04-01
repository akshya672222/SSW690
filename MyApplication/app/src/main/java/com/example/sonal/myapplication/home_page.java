package com.example.sonal.myapplication;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.view.MenuItemCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.ListView;
import android.support.v7.widget.SearchView;
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;

/**
 * Created by sonal on 2/12/2017.
 */

public class home_page extends AppCompatActivity implements NavigationView.OnNavigationItemSelectedListener, SearchView.OnQueryTextListener {

    MyListAdapter adapter;
    ListView list;
    private ArrayList<Event> events = new ArrayList<Event>();
    private ArrayList<Event> searchEvents = new ArrayList<Event>();

    private Toolbar toolbar;
    private ActionBarDrawerToggle mToggle;
    private DrawerLayout mDrawerLayout;

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.homepage);
        toolbar = (Toolbar)findViewById(R.id.app_bar);
        setSupportActionBar(toolbar);

        //for hamburger
        mDrawerLayout=(DrawerLayout)findViewById(R.id.homepage);
        mToggle = new ActionBarDrawerToggle(this,mDrawerLayout,R.string.open,R.string.close);
        mDrawerLayout.addDrawerListener(mToggle);
        mToggle.syncState();

        //to make hamburge appear on actionBar
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        Toast.makeText(getApplicationContext(), "Welcome!!",Toast.LENGTH_SHORT).show();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        populateEvents();
        populateListView();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_search, menu);
        MenuItem item = menu.findItem(R.id.menuSearch);
        SearchView searchView = (SearchView) MenuItemCompat.getActionView(item);
        searchView.setOnQueryTextListener(this);
        return true;
    }

    @Override
    public boolean onQueryTextSubmit(String query) {
        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText) {
        adapter.getFilter().filter(newText);
        return true;
    }

    //to enabled the action bar to take clicks
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if(mToggle.onOptionsItemSelected(item)){
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_Subscriptions) {
            Toast.makeText(getApplicationContext(), "Showing my subscription!!",Toast.LENGTH_SHORT).show();
            Intent intent = new Intent(getApplicationContext(), my_subscriptions.class);
            startActivity(intent);

        } else if (id == R.id.nav_Reminders) {

        } else if (id == R.id.nav_Grad_Admission) {

        } else if (id == R.id.nav_Alumni) {

        } else if (id == R.id.nav_Athletics) {

        } else if (id == R.id.nav_Career_Development) {

        } else if (id == R.id.nav_Conferences) {

        } else if (id == R.id.nav_Health) {
            // Handle the camera action
        } else if (id == R.id.nav_Open_to_public) {

        } else if (id == R.id.nav_Performing_and_Visual_Arts) {

        } else if (id == R.id.nav_Student_Life) {

        } else if (id == R.id.nav_Talks_and_Lectures) {

        } else if (id == R.id.nav_University_Wide) {

        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.homepage);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    private void populateEvents(){
        events.add(new Event("Seminar","Babbio 104","15 Feb 2017", 16.00));
        events.add(new Event("Lecture","Library","18 Feb 2017", 18.00));
        events.add(new Event("Free food","Howe 107","17 Feb 2017", 12.00));
        events.add(new Event("Seminar","Babbio 104","15 Feb 2017", 16.00));
        events.add(new Event("Lecture","Library","18 Feb 2017", 18.00));
        events.add(new Event("Free food","Howe 107","17 Feb 2017", 12.00));
        events.add(new Event("Seminar","Babbio 104","15 Feb 2017", 16.00));
        events.add(new Event("Lecture","Library","18 Feb 2017", 18.00));
        events.add(new Event("Free food","Howe 107","17 Feb 2017", 12.00));
    }
    private void populateListView(){
        adapter = new MyListAdapter(events.toArray(new Event[0]));
        list = (ListView) findViewById(R.id.list);
        list.setAdapter(adapter);
    }

    private class MyListAdapter extends ArrayAdapter<Event>{

        public MyListAdapter(final Event[] data){
            super(home_page.this, R.layout.item_view, data);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View eventView = convertView;
            if (eventView == null) {
                eventView = getLayoutInflater().inflate(R.layout.item_view, parent, false);
            }

            //find the event to work with not the original event
            Event selectedEvent = getItem(position);
            //Fill the view

            TextView eventName = (TextView) eventView.findViewById(R.id.eventName);
            eventName.setText(selectedEvent.getEventName());

            TextView eventVenue = (TextView) eventView.findViewById(R.id.venue);
            eventVenue.setText(selectedEvent.getEventVenue());

            TextView eventDate = (TextView) eventView.findViewById(R.id.date);
            eventDate.setText("" + selectedEvent.getEventDate());

            TextView eventTime = (TextView) eventView.findViewById(R.id.time);
            eventTime.setText("" + selectedEvent.getEventTime());
            return eventView;
        }
    }
}