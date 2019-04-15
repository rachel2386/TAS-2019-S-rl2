using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class recalculateNormals : MonoBehaviour
{
    // Start is called before the first frame update
    private SkinnedMeshRenderer myMF;
    private Mesh myMesh;
    private Camera myCam;
    public string objectName;
    public InputField myIF;
    private Dropdown myDD;
    
   
    void Start()
    {
        myCam = Camera.main;
        myDD = GameObject.Find("Dropdown").GetComponent<Dropdown>();
        myCam.cullingMask = 0<<0;
        //CheckWindingOrder();
    }

    public void FindGameObject()
    {
        //objectName = myIF.text;
        if (myDD.value == 0)
        {
           
            myCam.cullingMask = 0;
            
        }
        if (myDD.value == 1)
        {
            objectName = "humanMesh";
            myCam.cullingMask = ~(1 << LayerMask.NameToLayer("seal"));
            
        }
   
       else if (myDD.value == 2)
        {
            objectName = "sealMesh";
            myCam.cullingMask = ~(1 <<LayerMask.NameToLayer("human"));
           
        }

       
 
        myMF = GameObject.Find(objectName).GetComponent<SkinnedMeshRenderer>();
        myMesh = myMF.sharedMesh;
    }

    public void flipTris()
    {
        int[] tris  = myMesh.triangles;
        for (int i = 0; i< tris.Length; i+= 3)
        {
            int t = tris[i];
            tris[i] = tris[i+1];
            tris[i+1] = t;
        }
        myMesh.triangles = tris;
       
    }

    public void recalcNormals()
    {
        myMesh.RecalculateNormals();
    }

    void CheckWindingOrder()
    {
        var tri = myMesh.triangles;
        var verts = myMesh.vertices;
        var normals = myMesh.normals;
        float[] edges = new float[3 * tri.Length];
        float[] sum = new float[tri.Length];
       

        
                    
                        for (int j = 0; j <= tri.Length/2; j+=1)
                        {
                            edges[j] = (verts[tri[j]].x - verts[tri[j+1]].x) * (verts[tri[j]].y + verts[tri[j+ 1]].y); //edge1
                          
                        }
                        
                        for (int i = 0; i <= sum.Length; i++)
                        {
                            for (int edge = 0; edge <=edges.Length; edge+=3)
                            {
                        
                                sum[i] = edges[edge] + edges[edge+1] + edges[edge+2];

                                if (sum[i] < 0)
                                {
                                    print("counterClockwise");
                                }

                            }
                        }
            



              // 1 tri
    }
    // Update is called once per frame
    
}
