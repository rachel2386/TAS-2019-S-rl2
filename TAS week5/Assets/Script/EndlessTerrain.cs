using System.Collections.Generic;
using UnityEngine;


public class EndlessTerrain : MonoBehaviour
{
    //Purpose: to make a terrain treadmill by mapping chunks visible to player onto coordinates around them and invisible when distance > maxVisible 

    //1. get max distance in all dimensions from player to maxVisibleDistance
    //2. convert distance into number of chunks so we know how many chunks are visible and inside the visible distance radius 
    //3. Define a grid around the player and give all the visible spaces a coordinate.
    //4. check if there are no chunks in any of the visible coordinates, instantiate a new chunk there.
    //5. if there are, then make them visible. 

    // note: use a Dictionary to store all the positions of the chunks to determine if they are in visible range. 
    #region Public Tuning Var

    public Transform _PlayerTransform;
    public GameObject terrainObject;

    #endregion

    #region static Variables
    private static Vector3 playerPos;
    private static float maxViewDist = 100f;
    #endregion

    #region ChunkReference

    private int _chunkSize;
    private int _NumOfChunkVisibleIn1D;
    Dictionary<Vector3, TerrainChunks> _chunkCoordDict = new Dictionary<Vector3, TerrainChunks>();
    private List<TerrainChunks> TerrainVisibleLastFrame = new List<TerrainChunks>();

    #endregion 

    void Start()
    {

        _chunkSize = terrainObject.GetComponent<Chunk>().squareSize;
        _NumOfChunkVisibleIn1D = Mathf.RoundToInt(maxViewDist / _chunkSize);
        //if(terrainObject != null)
        //terrainBounds = terrainObject.GetComponent<Chunk>().myMeshBounds;

    }

    void Update()
    {
        playerPos = _PlayerTransform.position;
        UpdateVisibleChunks();
    }

    void UpdateVisibleChunks()
    {
        for (int i = 0; i < TerrainVisibleLastFrame.Count; i++)
        {
           TerrainVisibleLastFrame[i].meshObject.SetActive(false);
         
        }
        TerrainVisibleLastFrame.Clear();
        
        // coordinate of current player position
        int currentPlayerCoordX = Mathf.RoundToInt(playerPos.x / _chunkSize);
        int currentPlayerCoordZ = Mathf.RoundToInt(playerPos.z / _chunkSize);

        //instantiate chunks around current player pos within the visible grid bounds.   
        for (int xOffset = -_NumOfChunkVisibleIn1D; xOffset <= _NumOfChunkVisibleIn1D; xOffset++)
        {
            for (int zOffset = -_NumOfChunkVisibleIn1D; zOffset <= _NumOfChunkVisibleIn1D; zOffset++)
            {
                Vector3 visibleChunkPos = new Vector3(currentPlayerCoordX + xOffset, 0, currentPlayerCoordZ + zOffset);

                if (_chunkCoordDict.ContainsKey(visibleChunkPos))
                {
                    _chunkCoordDict[visibleChunkPos].CheckVisible();
                   
                    if (_chunkCoordDict[visibleChunkPos].ChunkIsActive())
                    {
                        TerrainVisibleLastFrame.Add(_chunkCoordDict[visibleChunkPos]);
                    }
               }
                else
                {
                    _chunkCoordDict.Add(visibleChunkPos,new TerrainChunks(terrainObject,visibleChunkPos,_chunkSize));
                }


            }
        }

        
    }

    private class TerrainChunks
    {
        public GameObject meshObject;
        private Bounds terrainBounds;
        private Vector3 position;
        public TerrainChunks(GameObject chunkObject, Vector3 coord, int chunkSize)
        {
            //Resources.Load("TerrainChunk") as GameObject;
            position = coord * chunkSize;
            meshObject = Instantiate(chunkObject,position,Quaternion.identity);
            terrainBounds = new Bounds(position,Vector3.one*chunkSize);
           // chunkObject.transform.parent = parent;
           meshObject.SetActive(false);

        }

       
      public void CheckVisible()
      {
         float playerDistfromChunkEdge = Mathf.Sqrt(terrainBounds.SqrDistance(playerPos));
          bool visible = playerDistfromChunkEdge <= maxViewDist;
            MakeVisible(visible);
        }

      void MakeVisible(bool visible)
      {
          meshObject.SetActive(visible);
      }

     public bool ChunkIsActive()
      {
          return meshObject.activeSelf;
      }
    }
}


   

