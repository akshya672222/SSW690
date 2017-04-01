package com.example.sonal.myapplication;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by sonal on 3/4/2017.
 */

public class my_subscriptions extends AppCompatActivity{
private ArrayList<String> categoryList = new ArrayList<>();
    private Toolbar toolbar;
    String cat[] = {"Seminar","Lecture","Free"};

    @Override
    public void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.subscriptions);
        replaceFont.replaceDefaultFont(this,"DEFAULT","arial.ttf");
        toolbar = (Toolbar)findViewById(R.id.app_bar);
        setSupportActionBar(toolbar);
        ListView lv = (ListView)findViewById(R.id.list);
        populateListContent();
        lv.setAdapter(new MyListAdapter(this, R.layout.category_item_view,categoryList));
        TextView doneTextView = (TextView)findViewById(R.id.doneTextView);

        doneTextView.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getApplicationContext(), home_page.class);
                startActivity(intent);

            }
        });
    }

    private void populateListContent(){
        for(int i =0; i<cat.length;i++){
            categoryList.add(cat[i]);
        }
    }
    private class MyListAdapter extends ArrayAdapter<String>

    {
        private int layout;

        public MyListAdapter(Context context, int resource, List<String> objects) {
            super(context, resource, objects);
            layout = resource;
        }
        @NonNull
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder mainViewHolder = null;
            if(convertView==null){
                LayoutInflater inflater = LayoutInflater.from(getContext());
                convertView=inflater.inflate(layout,parent,false);
                ViewHolder viewHolder = new ViewHolder();
                viewHolder.catName = (TextView)convertView.findViewById(R.id.categoryName);
                viewHolder.SubSwitch = (Switch) convertView.findViewById(R.id.subscriptionSwitch);
                String selectedcategory = categoryList.get(position);
                TextView categoryName = (TextView) convertView.findViewById(R.id.categoryName);
                categoryName.setText(selectedcategory);


                viewHolder.SubSwitch.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Toast.makeText(getContext(),"Button was clicked"+position, Toast.LENGTH_SHORT).show();
                    }
                });
                convertView.setTag(viewHolder);
            }
            else{
                mainViewHolder = (ViewHolder) convertView.getTag();
                mainViewHolder.catName.setText(getItem(position));
            }
            return convertView;
        }
    }
public class ViewHolder{
    TextView catName;
    Switch SubSwitch;
}
}


