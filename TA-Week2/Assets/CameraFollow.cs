using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using UnityEditor.U2D;
using UnityEditorInternal;
using UnityEngine;
using Quaternion = UnityEngine.Quaternion;
using Vector2 = UnityEngine.Vector2;
using Vector3 = UnityEngine.Vector3;

public class CameraFollow : MonoBehaviour
{
    private LookAtUnityBezier _myLAUB = new LookAtUnityBezier();

    private List<BezierSample> curveList;

    private Camera MainCam;
   

    private float travelledTime = 0;
    private float TimeInPec;
    public float TotTime = 5;
    

    private int currentIndex = 0;
    // Start is called before the first frame update
    void Start()
    {
        _myLAUB = GetComponent<LookAtUnityBezier>();
        curveList = _myLAUB.curveList;
        MainCam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
       CameraMovement();
       CameraRotation();
    }

    private void CameraMovement()
    {
        
        if (travelledTime < TotTime)
        {
            travelledTime += Time.deltaTime;
            
        }

        //if camera reaches the end of a curve
        if (travelledTime >= TotTime)
        {
          //t = 0
            travelledTime = 0;
          //if curve index is not the last on the list
           if(currentIndex < curveList.Count-1)
           {
               currentIndex++; 
           }
           else // if it is the last on the list
           {
               //camera loops back to the first curve
               currentIndex = 0;
           }

        }
        // v = 1  dis / time = 1   for v = same   dis /time = same  disInPer
        TimeInPec = travelledTime / TotTime;
        MainCam.transform.position = CalculateBez(curveList[currentIndex], TimeInPec);
        
    }

    void CameraRotation()
    {
        
               if (travelledTime > 0)
                 {
                     
                     Vector3 lastPoint= CalculateBez( curveList[currentIndex],travelledTime - Time.deltaTime);
                     Vector3 CurrentPos= CalculateBez(curveList[currentIndex],travelledTime);
                    MainCam.transform.LookAt (Vector3.Slerp(lastPoint, CurrentPos, 0.5f));
                    //Quaternion rotation = Quaternion.LookRotation(CurrentPos-lastPoint, Vector3.up);
                    //MainCam.transform.rotation = rotation;
                    // MainCam.transform.LookAt(Vector3.Slerp(CalculateBez( curveList[currentIndex-1],TotTime),CalculateBez( curveList[currentIndex],TotTime),0.5f));
                 }
                 else if (travelledTime <= 0)
                 {
                    
                     travelledTime = 0;
                     if (currentIndex > 0)
                     {
                         //slerp from the last point of the previous curve to the first point of the current curve
                         MainCam.transform.LookAt(Vector3.Slerp(CalculateBez(curveList[currentIndex -1],TotTime),CalculateBez(curveList[currentIndex],travelledTime),0.5f)); 
                     }
                     else // if currentIndex = 0 i.e. we are on the first point of the first curve
                     {
                         currentIndex = 0;
                         //look at currentPos
                         MainCam.transform.LookAt(Vector3.Slerp(CalculateBez(curveList[currentIndex],travelledTime),
                                                                CalculateBez(curveList[currentIndex],travelledTime + Time.deltaTime),
                                                                0.5f));
                     }

                    
                 }
           
           

    }

    private Vector3 CalculateBez(BezierSample curveData, float t)
    {
          
        Vector3 ab = Vector3.Lerp(curveData.startPoint,curveData.startTangent,t);
        Vector3 bc = Vector3.Lerp(curveData.startTangent,curveData.endTangent,t);
        Vector3 cd = Vector3.Lerp(curveData.endTangent,curveData.endPoint,t);
        Vector3 abc = Vector3.Lerp(ab,bc,t);
        Vector3 bcd = Vector3.Lerp(bc,cd,t);
        Vector3 finalCurve = Vector3.Lerp(abc,bcd,t);

        return finalCurve;

    }
    
    
}
