package com.example.sonal.myapplication;


import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by sonal on 3/14/2017.
 */

public class registration extends AppCompatActivity {

    final Context con = this;


    private View mProgressView;
    private View mLoginFormView;
    Button register;
    String server_response;

    EditText username, password, firstName, lastName;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.registration);
        username = (EditText) findViewById(R.id.username);
        password = (EditText) findViewById(R.id.password);
        firstName = (EditText) findViewById(R.id.firstName);
        lastName = (EditText) findViewById(R.id.lastName);

        register = (Button) findViewById(R.id.register);
        register.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                System.out.println("Register button clicked");
                attemptRegistration();
            }
        });

    }
    public void attemptRegistration(){
        System.out.println("calling register function");
        String usernameStr,passwordStr,firstNameStr,lastNameStr;
        usernameStr = username.getText().toString();
        passwordStr = password.getText().toString();
        firstNameStr = firstName.getText().toString();
        lastNameStr = lastName.getText().toString();
        new UserRegistrationTask(usernameStr, passwordStr,firstNameStr,lastNameStr).execute((Void) null);
    }
    public class UserRegistrationTask extends AsyncTask<Void, Void, Boolean> {
        String name, pwd, fName,lName;
        UserRegistrationTask(String username, String password,String firstNameStr, String lastNameStr) {
            name = username;
            pwd = password;
            fName = firstNameStr;
            lName = lastNameStr;
        }

        @Override
        protected Boolean doInBackground(Void... params) {
            try {
                System.out.println("Here in register doInbackground");
                int responseCode = register();
                if(responseCode==200){
                    System.out.println("Here I come");
                    Intent intent = new Intent(getApplicationContext(), home_page.class);
                    startActivity(intent);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return null;
        }
        private int register() throws IOException, JSONException {
            System.out.println("here in register");
            URL url = null;
            HttpURLConnection conn = null;

            url = new URL("http://10.0.2.2:5000/register");

            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(15000);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            System.out.println("Uname: "+name);
            System.out.println("Password: "+pwd);
            JSONObject requestObject = new JSONObject();
            requestObject.put("username", name);
            requestObject.put("password", pwd);
            requestObject.put("firstname", fName);
            requestObject.put("lastname", lName);

            System.out.println("strRequest: "+requestObject.toString());
            OutputStream os = conn.getOutputStream();
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
            System.out.println(requestObject);
            bw.write(requestObject.toString());
            bw.flush();
            int responseCode = conn.getResponseCode();
            System.out.println("responseCode is: "+responseCode);
            bw.close();
            os.close();
            conn.connect();
            return responseCode;
        }

    }
}