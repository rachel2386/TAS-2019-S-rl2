using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(LookAtUnityBezier))]
public class LAUBButton : Editor
{
    //LAUBButton is child of Editor, adding keyword override would prevent base method to be hidden
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        LookAtUnityBezier _MyLAUB = target as LookAtUnityBezier; //(target)LookAtUnityBezier, target means any variable in script

        if (GUILayout.Button("Make New Curve"))
        {
            
           
            BezierSample newCurve = _MyLAUB.myModel.gameObject.AddComponent<BezierSample>();

            if (_MyLAUB.curveList.Count > 0)
            {
               
                
                //Vector3 randomEndPoint = new Vector3(Random.Range(5f,10f),0,Random.Range(5f,10f));
                
                BezierSample LastInList =_MyLAUB.curveList[_MyLAUB.curveList.Count - 1] ;
                newCurve.startPoint = LastInList.endPoint;
                newCurve.startTangent = LastInList.endPoint + (LastInList.endPoint-LastInList.endTangent);
               newCurve.endTangent = LastInList.endPoint;
                newCurve.endPoint = LastInList.endPoint;
              //  Debug.Log("PosOfstartTangent" + LastInList.startTangent);
            }

           _MyLAUB.curveList.Add(newCurve);
        }

        if (GUILayout.Button("Remove Curve"))
        {
            if ( _MyLAUB.curveList.Count> 0)
            {
            BezierSample ButtomOnList = _MyLAUB.curveList[_MyLAUB.curveList.Count-1];
            DestroyImmediate(ButtomOnList);
            _MyLAUB.curveList.Remove(ButtomOnList);
            
            }
        }

        if (GUILayout.Button("Align Curves"))
        {
            BezierSample FirstCurve = _MyLAUB.curveList[0];
            BezierSample LastInList = _MyLAUB.curveList[_MyLAUB.curveList.Count-1];
                LastInList.endPoint = FirstCurve.startPoint;
               LastInList.endTangent = FirstCurve.startPoint + (FirstCurve.startPoint - FirstCurve.startTangent); 
           

        }
    }
}
