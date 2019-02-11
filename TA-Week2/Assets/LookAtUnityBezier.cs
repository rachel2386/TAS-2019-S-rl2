using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;
using Quaternion = UnityEngine.Quaternion;
using Vector3 = UnityEngine.Vector3;


[ExecuteInEditMode]
public class LookAtUnityBezier : MonoBehaviour

{
    [Header("Public References")]
    public GameObject marker;
    public BezierSample bezierCurve;
    public Transform myModel;
    public Vector3 PointsOnCurve;
    [Header("My Curves")]
    public List<BezierSample> curveList = new List<BezierSample>();
  

    void Start()
    {
        PlacePointsOnCurve();
    }

    public void PlacePointsOnCurve()
       {
//           //draw points on BezierCurve
//           for (int i = 0; i < 100; i++)
//           {
//               //(float)i means to cast i into a float
//               float t = (float)i / 100; // t moves 1/100 for i times
//              
//               //FinalCurve
//               PointsOnCurve = CalculateBezier(bezierCurve, t);
//               //instantiate 100 markers across curve
//               Instantiate(marker, PointsOnCurve, Quaternion.identity, null);
//           }
          
       }
       public Vector3 CalculateBezier(BezierSample curveData, float t)
       {
          
           Vector3 ab = Vector3.Lerp(curveData.startPoint,curveData.startTangent,t);
           Vector3 bc = Vector3.Lerp(curveData.startTangent,curveData.endTangent,t);
           Vector3 cd = Vector3.Lerp(curveData.endTangent,curveData.endPoint,t);
           Vector3 abc = Vector3.Lerp(ab,bc,t);
           Vector3 bcd = Vector3.Lerp(bc,cd,t);
           Vector3 FinalCurve = Vector3.Lerp(abc,bcd,t);

           return FinalCurve;

       }

      void UpdateHandlePos()
      {
         
          
          for(int i = 0; i < curveList.Count; i++)
          {
              if (i > 0)
              {
                  
                  BezierSample PreviousCurve = curveList[i-1];
                  BezierSample CurrentCurve = curveList[i];
                  CurrentCurve.startPoint = PreviousCurve.endPoint;
                  CurrentCurve.startTangent = PreviousCurve.endPoint +  (PreviousCurve.endPoint - PreviousCurve.endTangent);
              }
           else
              {
                  curveList[i].startPoint = curveList[0].startPoint;
                  curveList[i].startTangent = curveList[0].startTangent;
              }
          }
           
          
      }





       // Update is called once per frame
    void Update()
    {
        UpdateHandlePos();
        //Debug.Log("fukkkkk");


    }
}
