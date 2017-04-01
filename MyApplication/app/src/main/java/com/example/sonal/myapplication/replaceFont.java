package com.example.sonal.myapplication;

import android.content.Context;
import android.graphics.Typeface;

import java.lang.reflect.Field;

/**
 * Created by sonal on 3/5/2017.
 */

public class replaceFont {
    public static void replaceDefaultFont(Context context, String oldFont, String newFont){
        System.out.println("I am here finally"+context.getAssets().toString());
        System.out.println("I am here finally"+context.getAssets());
        Typeface customFontTypeFace = Typeface.createFromAsset(context.getAssets(),newFont);
        replaceFont(oldFont,customFontTypeFace);
    }

    private static void replaceFont(String oldFont, Typeface customFontTypeFace){
try{
    Field myField = Typeface.class.getDeclaredField(oldFont);
    myField.setAccessible(true);
    myField.set(null,customFontTypeFace);


}catch(NoSuchFieldException e){

} catch (IllegalAccessException e) {
    e.printStackTrace();
}
    }

}
