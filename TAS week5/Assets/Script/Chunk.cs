using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml.Linq;
using UnityEditor;
using UnityEditor.IMGUI.Controls;
using UnityEngine;
using Random = UnityEngine.Random;

[RequireComponent(typeof(MeshFilter),typeof(MeshRenderer))]
public class Chunk : MonoBehaviour
{
    // Start is called before the first frame update
    #region Internal References

    private MeshFilter _myMf;
    private MeshRenderer _myMr;
    private Mesh _myMesh;
    //verts
    private Vector3[] _verts;
    //tris
    private int[] _tris;
    //normals
    private Vector3[] _normals;
    //uvs
    private Vector2[] _uVs;

    private int _totVertInd;
    private int _totTriInd;
#endregion    
    

    #region Public References
 
    public float heightScale = 8.0f;
    public float detailScale = 5.0f;
    public int squareSize = 20;
    
    #endregion

    private void Awake()
    {
        _myMf = gameObject.GetComponent<MeshFilter>();
        _myMr = gameObject.GetComponent<MeshRenderer>();
        _myMesh = new Mesh();
    }

    private void Start()
    {
        Initialize();
        CalMesh();
        ApplyMesh();
    }

    private void Initialize()
    {
      
        _totVertInd = (squareSize + 1) * (squareSize + 1);
        _totTriInd = (squareSize * squareSize) * 2 * 3;
        _verts = new Vector3[_totVertInd];
        _tris = new int[_totTriInd];
        _normals = new Vector3[_totVertInd];
        _uVs  = new Vector2[_totVertInd];
    }

    private void CalMesh()
    {
    
        //num of verts in a row = squareSize

        for (int z = 0; z <= squareSize; z ++)
        {
            for (int x = 0; x <= squareSize; x++)
            {

                for (int y = 0; y <= squareSize; y++)
                {
                    
                    
                    // _verts[z * (squareSize+1)] is the index of the first vertex on row z 
                    //  + x vertices on that row
                
                    //example: 
//  row 1              _verts[1 *squareSize + 1] = new Vector3(squareSize,0,1);
//  row 2              _verts[2 * squareSize + 1] = new Vector3(squareSize,0,2);
//  row 3              _verts[3 * squareSize + 1] = new Vector3(squareSize, 0, 3);

                     
                   
                    //referring to Dong's code 
                    //calculate normals
                    var v0 = new Vector3(x, 
                        heightScale * Perlin.Noise(
                            ((float)x + transform.position.x) / detailScale, 
                            ((float)z + transform.position.z) / detailScale), 
                        z);
                    var v1 = new Vector3(x + 1, 
                        heightScale * Perlin.Noise(
                            ((float)(x + 1) + transform.position.x) / detailScale, 
                            ((float)z + transform.position.z) / detailScale), 
                        z);
                    var v2 = new Vector3(x + 1, 
                        heightScale * Perlin.Noise(
                            ((float)(x + 1) + transform.position.x) / detailScale, 
                            ((float)(z + 1) + transform.position.z) / detailScale), 
                        z + 1);
                    var v3 = new Vector3(x - 1, 
                        heightScale * Perlin.Noise(
                            ((float)(x - 1) + transform.position.x) / detailScale, 
                            ((float)(z + 1) + transform.position.z) / detailScale), 
                        z + 1);
                    var v4 = new Vector3(x - 1, 
                        heightScale * Perlin.Noise(
                            ((float)(x - 1) + transform.position.x) / detailScale, 
                            ((float)(z - 1) + transform.position.z) / detailScale), 
                        z - 1);
                    var d1 = (v1 - v0).normalized;
                    var d2 = (v2 - v0).normalized;
                    var d3 = (v3 - v0).normalized;
                    var d4 = (v4 - v0).normalized;

                    _verts[z * (squareSize + 1) + x] = v0;
                    
                    //_verts[z * (squareSize + 1) + x] = new Vector3(x,0f,z);
//                        y = Mathf.PerlinNoise((x + this.transform.position.x) / detailScale,
//                                (z + this.transform.position.z) / detailScale) * heightScale
                   
                    
                    _normals[z * (squareSize + 1) + x] = 
                            -(Vector3.Cross(d1,d2)
                            +Vector3.Cross(d2,d3)
                            +Vector3.Cross(d3,d4)
                            +Vector3.Cross(d4,d1)).normalized;
                }
                

               
           
            }
        }
        //calculate tris
        for (int z = 0, i=0; z < squareSize; z++)
        {
            for (int x = 0; x < squareSize; x++)// dont want vert[i+square+2]to exceed bounds
            {
                
                int bottomLeft = x + z*(squareSize+1);
                int topLeft = x + (z+1)*(squareSize+1);
                int bottomRight =x+1 + z*(squareSize+1) ;
                int topRight =(x+ 1 + (z+1)*(squareSize+1));

                _tris[i] = bottomLeft;
                i++;
                _tris[i] = topLeft;
                i++;
                _tris[i] = bottomRight;
                i++;
                _tris[i] = bottomRight;
                i++;
                _tris[i] = topLeft;
                i++;
                _tris[i] = topRight;
                i++;

            }
        }
   
    }

    private void ApplyMesh()
    {
        _myMesh.vertices = _verts;
        _myMesh.triangles = _tris;
        //MyMesh.RecalculateNormals();
        _myMesh.normals = _normals;

        _myMf.mesh = _myMesh;
        _myMr.material = Resources.Load<Material>("MyMat");
        
    }


//    private void OnDrawGizmos()
//    {
//        if (_verts == null)
//            return;
//        
//        for (int i = 0; i < _verts.Length; i++)
//        {
//            Gizmos.DrawSphere(_verts[i],0.1f);
//        }
//    }

   
   
}
