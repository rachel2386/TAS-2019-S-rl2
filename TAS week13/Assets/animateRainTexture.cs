using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class animateRainTexture : MonoBehaviour
{
    // Start is called before the first frame update

    public Material RainEffectMaterial;
    public Material QuadMat;
    private Material myMat;
    public bool surface = false;
    private string[] textureNames;
    private List<Texture2D> rainTextures = new List<Texture2D>(); 
    private int arrayIndex = 0;
    void Start()
    {
        //RainEffectMaterial = GetComponent<Renderer>().material;
        
        
        string filePath = Application.dataPath + "/Resources/Drops";
       textureNames = Directory.GetFiles(filePath, "*.jpg");
      
      //store raindrop textures names into array
       for (int i = 0; i < textureNames.Length; i++)
        {
            string newLine = textureNames[i].Replace("D:/content/others/nyu/gradClasses/TechArt/TAS-2019-S-rl2/TAS week13/Assets/Resources/Drops" + "\\", "");
          textureNames[i] = newLine;
          //print("File Loaded:" +  "Drops/" + textureNames[i]);
        Texture2D rainText = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Resources/Drops/" + textureNames[i]);
        rainTextures.Add(rainText);
        // rainTextures.Add(Resources.Load<Texture2D>("Drops/" + textureNames[i]));
           
        }

       if (surface)
           myMat = QuadMat;
       else
           myMat = RainEffectMaterial;
        
       
        myMat.SetTexture("_RainTexture", rainTextures[arrayIndex]);
        
        if(surface)
        myMat.mainTexture =  myMat.GetTexture("_RainTexture");
        //ainEffectMaterial.SetTexture("DistortionTexture", rainTextures[arrayIndex]);
       //QuadMat.mainTexture = rainTextures[arrayIndex];
       //QuadMat.SetTextureScale("_MainTex", new Vector2(Screen.width, Screen.height) * RainEffectMaterial.GetFloat("_Tiling"));
       

        //attempt to copy old string content to new string
//        foreach (string line in rainTextures)
//        {
////            char[] oldLine = line.ToCharArray();
////            char[] newLine = new char[19];
////            Array.Copy(oldLine,86,newLine,0,19);
////            line.Equals(newLine.ToString());
////            
////            line = newLine.ToString();
//              
//        }
        
            //use a file to keep track of all the names 
             string textureFile = filePath + "/textureList.txt";
            File.WriteAllLines(textureFile,textureNames);
 



    }

    // Update is called once per frame
   
    void Update()
    {
//     
        if (rainTextures.Count > 0)
        {
            if (arrayIndex <= rainTextures.Count - 1)
                arrayIndex++;
            else
                arrayIndex = 0;

            if (arrayIndex >= 0 && arrayIndex < rainTextures.Count)
            {
                
                myMat.SetTexture("_RainTexture", rainTextures[arrayIndex]);
                if(surface)
                    myMat.mainTexture =  myMat.GetTexture("_RainTexture");
               // RainEffectMaterial.SetTexture("DistortionTexture", rainTextures[arrayIndex]);
                //QuadMat.mainTexture = rainTextures[arrayIndex];
            }

           
           
            
        }

        
        
        
    }


}
