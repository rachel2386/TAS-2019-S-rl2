using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(BezierSample))]
public class DrawBezierCurve : Editor
{
    private void OnSceneViewGUI(SceneView sv)
    {
       BezierSample be = target as BezierSample;

       be.startPoint = Handles.PositionHandle(be.startPoint, Quaternion.identity);
       be.endPoint = Handles.PositionHandle(be.endPoint, Quaternion.identity);
       be.startTangent = Handles.PositionHandle(be.startTangent, Quaternion.identity);
       be.endTangent = Handles.PositionHandle(be.endTangent, Quaternion.identity);
       
       Handles.DrawBezier(be.startPoint,be.endPoint,be.startTangent,be.endTangent,Color.green, null,3f);
    }

    private void OnEnable()
    {
        //In the list of editor functions to start, add our custom function 
        SceneView.onSceneGUIDelegate += OnSceneViewGUI;
        
    }
    
    private void OnDisable()
    {
        SceneView.onSceneGUIDelegate -= OnSceneViewGUI;
        
    }
}
