package com.example.sonal.myapplication;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.text.InputType;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class MainActivity extends AppCompatActivity {

    final Context con = this;
    private UserLoginTask mAuthTask = null;

    Button logInBtn,registerBtn;
    TextView forgotPassword;


    EditText  userName, mPasswordView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        replaceFont.replaceDefaultFont(this,"DEFAULT","arial.ttf");
        logInBtn = (Button)findViewById(R.id.logInBtn);
        registerBtn = (Button)findViewById(R.id.registerBtn);
        userName = (EditText)findViewById(R.id.userName);
        mPasswordView= (EditText)findViewById(R.id.password);
        forgotPassword = (TextView) findViewById(R.id.forgotPassword);

        logInBtn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                attemptLogin();
            }
        });
        registerBtn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getApplicationContext(), registration.class);
                startActivity(intent);
            }
        });

        forgotPassword.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                //Intent intent = new Intent(getApplicationContext(), forgotPassword.class);
                //startActivity(intent);

                MainActivity.this.runOnUiThread(new Runnable() {
                    public void run() {
                        showDialogForEmail();
                    }
                });



            }
        });

    }
    private void showDialogForEmail(){
        View view = (LayoutInflater.from(MainActivity.this)).inflate(R.layout.forgotpassword,null);
        final AlertDialog.Builder builder = new AlertDialog.Builder(getApplicationContext());
        builder.setView(view);
        EditText input = (EditText)view.findViewById(R.id.email);
        builder.setTitle("Enter the Email ID");

        input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);

        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                System.out.println("I am here for forgot");
            }
        });
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

            }
        });

        Dialog dialog = builder.create();
        dialog.show();
    }
    private void attemptLogin() {
        if (mAuthTask != null) {
            return;
        }
        // Reset errors.
        mPasswordView.setError(null);
        // Store values at the time of the login attempt.
        String email = userName.getText().toString();
        String password = mPasswordView.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid password, if the user entered one.
        if (!TextUtils.isEmpty(password) && !isPasswordValid(password)) {
            mPasswordView.setError(getString(R.string.error_invalid_password));
            focusView = mPasswordView;
            cancel = true;
        }

        // Check for a valid email address.
        if (TextUtils.isEmpty(email)) {
            userName.setError(getString(R.string.error_field_required));
            focusView = userName;
            cancel = true;
        } else if (!isEmailValid(email)) {
            userName.setError(getString(R.string.error_invalid_email));
            focusView = userName;
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
        } else {
            // Show a progress spinner, and kick off a background task to
            // perform the user login attempt.

            mAuthTask = new UserLoginTask(email, password);
            mAuthTask.execute((Void) null);
        }
    }
    private boolean isEmailValid(String email) {
        //TODO: Replace this with your own logic
        // if(email.length()>50 || email.indexOf("stevens.edu")<0){
        //return false;
        //   }
        //  return email.contains("@");
        return true;
    }
    private boolean isPasswordValid(String password) {
        //TODO: Replace this with your own logic
        return true;//password.length() > 4;
    }

    public class UserLoginTask extends AsyncTask<Void, Void, Boolean> {

        private final String mEmail;
        private final String mPassword;

        UserLoginTask(String email, String password) {
            mEmail = email;
            mPassword = password;
        }

        @Override
        protected Boolean doInBackground(Void... params) {
            // TODO: attempt   against a network service.

            try {
                int responseCode = connect();
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

            // TODO: register the new account here.
            return true;
        }

        @Override
        protected void onPostExecute(final Boolean success) {
            System.out.println("I am here in onPostExecute");
            mAuthTask = null;
        }

        @Override
        protected void onCancelled() {
            mAuthTask = null;
        }

        private int connect() throws IOException, JSONException {
            URL url = null;
            StringBuilder sb = new StringBuilder();
            HttpURLConnection conn = null;

            url = new URL("http://10.0.2.2:5000/login");

            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(15000);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            /*Uri.Builder builder = new Uri.Builder();
            builder.appendQueryParameter("username", "sonali");
            builder.appendQueryParameter("password", "patil");
            String urlQuery = builder.build().getEncodedQuery();
            */
            System.out.println("Uname: "+mEmail);
            System.out.println("Password: "+mPassword);

            JSONObject requestObject = new JSONObject();
            requestObject.put("username", mEmail);
            requestObject.put("password", mPassword);

            OutputStream os = conn.getOutputStream();
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
                System.out.println(requestObject.toString());
            bw.write(requestObject.toString());
            bw.flush();
            int responseCode = conn.getResponseCode();
            System.out.println("responseCode is: "+responseCode);
            bw.close();
            os.close();
            conn.connect();


           /* BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String line = "";
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }

            System.out.println("Connection object is: " + conn);
            int responseCode = 0;

            responseCode = conn.getResponseCode();
*/
            System.out.println("responseCode is: " + responseCode);
            return responseCode;
        }

    }

}
