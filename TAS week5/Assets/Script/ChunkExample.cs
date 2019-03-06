using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkExample : MonoBehaviour
{
    private MeshFilter _myMF;
    private MeshRenderer _myMR;

    private Mesh _myMesh;

    private Vector3[] _verts;
    private int[] _tris;
    private Vector2[] _uVs;
    private Vector3[] _normals;

    public int sizeSquare;
    private int _totalVertInd;
    private int _totalTrisInd;

    private void Awake()
    {
        _myMF = gameObject.AddComponent<MeshFilter>();
        _myMR = gameObject.AddComponent<MeshRenderer>();

        _myMesh = new Mesh();
    }

    private void Start()
    {
        _Init();
        _CalcMesh();
        _ApplyMesh();
    }

    private void _Init()
    {
        _totalVertInd = (sizeSquare + 1) * (sizeSquare + 1);
        _totalTrisInd = (sizeSquare) * (sizeSquare) * 2 * 3;
        _verts = new Vector3[_totalVertInd];
        _tris = new int[_totalTrisInd];
        _uVs = new Vector2[_totalVertInd];
        _normals = new Vector3[_totalVertInd];
    }

    private void _CalcMesh()
    {
        for (int z = 0; z <= sizeSquare; z++)
        {
            for (int x = 0; x <= sizeSquare; x++)
            {
                _verts[(z * (sizeSquare + 1)) + x] = 
                    new Vector3(x, 
                    10 * Perlin.Noise(
                        ((float)x + transform.position.x) / 8, 
                        ((float)z + transform.position.z) / 8), 
                    z);
            }
        }

        int _triInd = 0;

        for (int i = 0; i < sizeSquare; i++)
        {
            for (int j = 0; j < sizeSquare; j++)
            {
                int bottomLeft = j + (i * (sizeSquare + 1)); // true as long as j < sizesquare - 1
                int bottomRight = j + (i * (sizeSquare + 1)) + 1; // true as long as j < sizesquare -1
                int topLeft = j + ((i + 1) * (sizeSquare + 1));
                int topRight = j + ((i + 1) * (sizeSquare + 1)) + 1;

                _tris[_triInd] = bottomLeft;
                _triInd++;
                _tris[_triInd] = topLeft;
                _triInd++;
                _tris[_triInd] = bottomRight;
                _triInd++;
                _tris[_triInd] = topLeft;
                _triInd++;
                _tris[_triInd] = topRight;
                _triInd++;
                _tris[_triInd] = bottomRight;
                _triInd++;
            }
        }
    }

    private void _ApplyMesh()
    {
        _myMesh.vertices = _verts;
        _myMesh.triangles = _tris;
        _myMesh.RecalculateNormals();

        _myMF.mesh = _myMesh;

        _myMR.material = Resources.Load<Material>("MyMat");
    }

}
