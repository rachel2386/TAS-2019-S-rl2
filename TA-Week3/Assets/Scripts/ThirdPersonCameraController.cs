using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using UnityEngine;

public class ThirdPersonCameraController : MonoBehaviour {

    //Camera Features
    //Camera Looks at Scenery on Idle State
    //Camera looks at object of interest when detected by overlapping sphere
    //Camera changes fov when looking at different angles 
    //different camera distance when looking up and down
    //Smooth camera movements and fov with lerps and moveTowards
    
 
    
    #region Internal References
    private Transform _app;
    private Transform _view;
    private Transform _cameraBaseTransform;
    private Transform _cameraTransform;
    private Transform _cameraLookTarget;
    private Transform _avatarTransform;
    private Rigidbody _avatarRigidbody;
    private Camera _camCamera;
    
    
    #endregion

    #region Public Tuning Variables
    public Vector3 avatarObservationOffset_Base;
    //public Vector3 WEVObservationOffset_Base;
    //public Vector3 BEVObservationOffset_Base;
    public float followDistance_Base;
    public float verticalOffset_Base;
    public float pitchGreaterLimit;
    public float pitchLowerLimit;
    public float fovAtUp;
    public float fovAtDown;

    [Header("Idle Cameras")] 
    public Camera SceneCam1;
    public Camera SceneCam2;
    public Camera FrontCam;

    public int OOIFOV = 60;
    public int WEVFOV = 30;
    public int BEVFOV = 30;
    
    #endregion

    #region Persistent Outputs
    //Positions
    private Vector3 _camRelativePostion_Auto;
    private Vector3 _LookTarOffset;
    
    

    //Directions
    private Vector3 _avatarLookForward;

    //Scalars
    private float _followDistance_Applied;
    private float _verticalOffset_Applied;
    
    //states
    private CameraStates _currentState;
    
    //otherStuff
    private Collider[] _stuffInSphere;
    private Collider[] _WEVSphereCols;
    
    //Timers
   private float _IdleTimer =0f;
   private float StartIdleTime = 15f;
    
    #endregion

    private void Awake()
    {
        _app = GameObject.Find("Application").transform;
        _view = _app.Find("View");
        _cameraBaseTransform = _view.Find("CameraBase");
        _cameraTransform = _cameraBaseTransform.Find("Camera");
        _cameraLookTarget = _cameraBaseTransform.Find("CameraLookTarget");
        _camCamera = _cameraTransform.gameObject.GetComponent<Camera>();
        _avatarTransform = _view.Find("AIThirdPersonController");
        _avatarRigidbody = _avatarTransform.GetComponent<Rigidbody>();
    }

    
    private void Start()
    {
        _currentState = CameraStates.Automatic;
        _LookTarOffset = _cameraLookTarget.localPosition;
    }

    private void Update()
    {
        _IdleTimer += Time.deltaTime;
       print(_IdleTimer);
        if (Input.GetMouseButton(1))
        {
            
            _currentState = CameraStates.Manual;
        }
            
        else if (!Input.GetMouseButton(1) && !Input.GetMouseButton(0) && _IdleTimer >=StartIdleTime)
        {
            
            _currentState = CameraStates.Idle;
        }
        else
        {
           _currentState = CameraStates.Automatic;
        }

        if (_currentState == CameraStates.Automatic)
        {
            _AutoUpdate();
        }
        else if (_currentState == CameraStates.Manual)
        {
            _ManualUpdate();
        }
        else
        {
            
            _IdleUpdate();
        }

        if (_currentState != CameraStates.Idle)
        {
            StopCoroutine(CameraIdling(StartIdleTime));
            _camCamera.enabled = true;
            SceneCam1.enabled = false;
            SceneCam2.enabled = false;
            FrontCam.enabled = false; 
        }

        if (Input.GetMouseButton(0) || Input.GetMouseButton(1))
        {
            _IdleTimer = 0;
        }


    }

    #region Debug

    
    
//    private void OnDrawGizmos()
//    {
//        Gizmos.color = Color.green;
//        Gizmos.DrawWireSphere(_avatarTransform.position,5);
//        Gizmos.color = Color.red;
//        Gizmos.DrawWireSphere(_avatarTransform.position + new Vector3(0,15f,0),8f);
//    }
    #endregion
    
    #region States
    private void _AutoUpdate()
    {
        
       
        _ComputeData();
        _FollowAvatar();
        _CameraLookAt();
        

    }
    private void _ManualUpdate()
    {
        
       _FollowAvatar();
        _ManualControl();
    }

    private void _IdleUpdate()
    {
       
        //Camera Looks at Scenery
        StartCoroutine(CameraIdling(StartIdleTime));
    }

    #endregion

    #region Internal Logic

    float _standingToWalkingSlider = 0;
    private float AvatarToObjSlider = 0;
    float wevSlider = 0;
    private float bevSlider = 0;
    private float VerticalDistanceSlider = 0;
    float _ExtraVerticalDis;
    float _ExtraHorizontalDis;
    
    private void _ComputeData()
    {
        _stuffInSphere = Physics.OverlapSphere(_avatarTransform.position, 6);
        _avatarLookForward = Vector3.Normalize(Vector3.Scale(_avatarTransform.forward, new Vector3(1, 0, 1)));

        if (_Helper_IsWalking())
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 1, Time.deltaTime * 3);
        }
        else
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 0, Time.deltaTime);
        }

        float _followDistance_Walking = followDistance_Base;
        float _followDistance_Standing = followDistance_Base * 2;

        float _verticalOffset_Walking = verticalOffset_Base;
        float _verticalOffset_Standing = verticalOffset_Base * 3;

        _followDistance_Applied = Mathf.Lerp(_followDistance_Standing, _followDistance_Walking, _standingToWalkingSlider);
        _verticalOffset_Applied = Mathf.Lerp(_verticalOffset_Standing, _verticalOffset_Walking, _standingToWalkingSlider);
        
        
       //change camera distance when looking up or down 
        if (_Helper_InWEVMode())
        {
            _ExtraVerticalDis = Mathf.MoveTowards(_ExtraVerticalDis, 1f, 0.3f);
            _ExtraHorizontalDis = Mathf.MoveTowards(_ExtraHorizontalDis, 2.3f, 0.3f);
        }
        else if(_Helper_InBEVMode())
        {
            _ExtraVerticalDis = Mathf.MoveTowards(_ExtraVerticalDis, 4f, 0.05f);;
            _ExtraHorizontalDis = Mathf.MoveTowards(_ExtraHorizontalDis, 3f, 0.05f);
        }
        else
        {
            _ExtraVerticalDis = Mathf.Lerp(_ExtraVerticalDis,1, 0.3f*Time.deltaTime);
            _ExtraHorizontalDis = Mathf.Lerp(_ExtraHorizontalDis,1,0.3f*Time.deltaTime);
        }
        
    }

    private void _FollowAvatar()
    {
        _camRelativePostion_Auto = _avatarTransform.position;
        Debug.Log("OOI is here " + _Helper_IsThereOOI() + " IN WEVMode = " + _Helper_InWEVMode() + "IN BEvMode " + _Helper_InBEVMode());
       
        if (_Helper_IsThereOOI())
        {
            _LookAtObject();
        }
        else if (_Helper_InWEVMode())
        {
            _WormsEyeView();
        }
        else if(_Helper_InBEVMode())
        {
            _BirdsEyeView();
        }
        else
        {
           _cameraLookTarget.position =  Vector3.Lerp(_avatarTransform.position + avatarObservationOffset_Base, _cameraLookTarget.position,0.5f * Time.deltaTime); 
           _camCamera.fieldOfView = Mathf.MoveTowards(_camCamera.fieldOfView,40f,0.3f);
        }

       _cameraTransform.position = _avatarTransform.position - _avatarLookForward * _followDistance_Applied * _ExtraHorizontalDis + Vector3.up * _verticalOffset_Applied * _ExtraVerticalDis;
    }

    private void _CameraLookAt()
    {
        if (_Helper_IsThereOOI())
        {
            _LookAtObject();
        }
        else if (_Helper_InWEVMode())
        {
            _WormsEyeView();
        }
        else if(_Helper_InBEVMode())
        {
            _BirdsEyeView();
        }
        else
        {
            _cameraLookTarget.localPosition = Vector3.MoveTowards(_cameraLookTarget.localPosition, _LookTarOffset, 0.5f);
            _camCamera.fieldOfView = Mathf.MoveTowards(_camCamera.fieldOfView,40f,0.5f);
            // _cameraTransform.localEulerAngles = Vector3.Lerp(_cameraTransform.localEulerAngles, relativeRot, 5);
            _cameraTransform.LookAt(_cameraLookTarget.position); 
        }

      
       
    }

    private void _LookAtObject()
    {
        AvatarToObjSlider = Mathf.MoveTowards(AvatarToObjSlider, 1, Time.deltaTime * 3 );
        Vector3 LookPos = avatarObservationOffset_Base + Vector3.Lerp(_avatarTransform.position,_Helper_WhatIsClosestOOI().position,0.3f);
            
        _cameraLookTarget.position = Vector3.Lerp(_avatarTransform.position + avatarObservationOffset_Base,LookPos,AvatarToObjSlider);
            
        _camCamera.fieldOfView = Mathf.MoveTowards(_camCamera.fieldOfView,OOIFOV,0.3f);
        _cameraTransform.LookAt(_cameraLookTarget);
        

    }

    private void _WormsEyeView()
    {
        wevSlider = Mathf.MoveTowards(wevSlider, 1, Time.deltaTime * 3 );
        Vector3 LookPos = avatarObservationOffset_Base + Vector3.Lerp(_avatarTransform.position,_Helper_WEVTrgt().position,0.4f);
        _cameraLookTarget.position = Vector3.Lerp(_avatarTransform.position + avatarObservationOffset_Base,LookPos,wevSlider);
        _camCamera.fieldOfView = Mathf.MoveTowards(_camCamera.fieldOfView,WEVFOV,0.3f);
        _cameraTransform.LookAt(_cameraLookTarget);
  
    }
    
    private void _BirdsEyeView()
    {
        bevSlider =Mathf.MoveTowards(bevSlider, 1, 0.05f );
        _cameraLookTarget.position =  Vector3.Lerp( _avatarTransform.position+ avatarObservationOffset_Base,
                                                    _avatarTransform.position+ avatarObservationOffset_Base+_avatarTransform.forward*2,
                                                     bevSlider); 
        _camCamera.fieldOfView = Mathf.MoveTowards(_camCamera.fieldOfView,BEVFOV,0.2f);
        _cameraTransform.LookAt(_cameraLookTarget);
    
    }

    private void _ManualControl()
    {
        Vector3 _camEulerHold = _cameraTransform.localEulerAngles;

        if (Input.GetAxis("Mouse X") != 0)
            _camEulerHold.y += Input.GetAxis("Mouse X");

        if (Input.GetAxis("Mouse Y") != 0)
        {
            float temp = _camEulerHold.x - Input.GetAxis("Mouse Y");
            temp = (temp + 360) % 360;

            if (temp < 180)
                temp = Mathf.Clamp(temp, 0, 80);
            else
                temp = Mathf.Clamp(temp, 360 - 80, 360);

            _camEulerHold.x = temp;
        }

       // Debug.Log("The V3 to be applied is " + _camEulerHold);
        _cameraTransform.localRotation = Quaternion.Euler(_camEulerHold);
    }
    #endregion

    #region Helper Functions

    private Vector3 _lastPos;
    private Vector3 _currentPos;
    
    private bool _Helper_IsWalking()
    {
        _lastPos = _currentPos;
        _currentPos = _avatarTransform.position;
        float velInst = Vector3.Distance(_lastPos, _currentPos) / Time.deltaTime;

        if (velInst > .15f)
            return true;
        else return false;
    }


    private bool _Helper_InBEVMode()
    {
        bool LookingDown = false;

        for (int i = 0; i < _stuffInSphere.Length; i++)
        {
            if (_stuffInSphere[i].gameObject.CompareTag("BirdEye"))
            {
                LookingDown = true;
            }
        }

//        Ray ray = new Ray(_avatarTransform.position + _avatarLookForward*4f,Vector3.down);
//        RaycastHit hit = new RaycastHit();
//        //bool _StuffHit = Physics.Raycast(ray, out hit, 15f);
//         bool StuffHit = Physics.SphereCast(ray, 8, out hit,15f);
//         if (StuffHit)
//         {
//             if (hit.collider.gameObject.CompareTag("BirdEye"))
//            {
//             LookingDown = true;
//             Debug.DrawLine(_avatarTransform.position + _avatarLookForward*4f,Vector3.down * hit.distance,Color.magenta );
//            }
//         }

         
        return LookingDown;
    }
    private Transform _Helper_BEVTrgt()
    {
       
        List<Transform> TrgtTransform = new List<Transform>();
        List<float> trgtDistance = new List<float>();
        
        TrgtTransform.Clear();
        trgtDistance.Clear();

        
        foreach (Collider trgt in _stuffInSphere)
        {
            if (trgt.gameObject.CompareTag("BirdEye"))
            {
                Transform trgtTrans = trgt.gameObject.transform;
                TrgtTransform.Add(trgtTrans);
            
                float trgtDisToAvatar = Vector3.Distance(trgtTrans.position, _avatarTransform.position);
                trgtDistance.Add(trgtDisToAvatar);
            }

        }
        int indexOfMinDisTrgt = trgtDistance.IndexOf(trgtDistance.Min());
        Transform closestTrgt = TrgtTransform[indexOfMinDisTrgt];
      
        return closestTrgt;
        



    }
    private bool _Helper_InWEVMode()
    {
        bool LookingUp = false;
        

       _WEVSphereCols = Physics.OverlapSphere(_avatarTransform.position + new Vector3(0,15,0), 8f);
        
        
        for (int i = 0; i < _WEVSphereCols.Length; i++)
        {
            if (_WEVSphereCols[i].gameObject.CompareTag("WormsEye"))
                LookingUp = true;
        }
        return LookingUp;
    }
    
    private Transform _Helper_WEVTrgt()
    {
       
        List<Transform> TrgtTransform = new List<Transform>();
        List<float> trgtDistance = new List<float>();
        
        TrgtTransform.Clear();
        trgtDistance.Clear();

        
        foreach (Collider trgt in _WEVSphereCols)
        {
            if (trgt.gameObject.CompareTag("WormsEye"))
            {
                Transform trgtTrans = trgt.gameObject.transform;
                TrgtTransform.Add(trgtTrans);
            
                float trgtDisToAvatar = Vector3.Distance(trgtTrans.position, _avatarTransform.position);
                trgtDistance.Add(trgtDisToAvatar);
            }

        }
        int indexOfMinDisOoi = trgtDistance.IndexOf(trgtDistance.Min());
        Transform closestTrgt = TrgtTransform[indexOfMinDisOoi];
      
        return closestTrgt;
        



    }

    private bool _Helper_IsThereOOI()
    {
       
       

        bool _OOIPresent = false;

        for (int i = 0; i < _stuffInSphere.Length; i++)
        {
            if (_stuffInSphere[i].CompareTag("ObjectOfInterest"))
                _OOIPresent = true;
        }

        return _OOIPresent;

  
    }

    private Transform _Helper_WhatIsClosestOOI()
    {
       
        List<Transform> ooiTransform = new List<Transform>();
        List<float> ooiDistance = new List<float>();
        
        ooiTransform.Clear();
        ooiDistance.Clear();

        
        foreach (Collider ooi in _stuffInSphere)
        {
            if (ooi.gameObject.CompareTag("ObjectOfInterest"))
            {
                Transform ooiTrans = ooi.gameObject.transform;
                ooiTransform.Add(ooiTrans);
            
                float ooiDisToAvatar = Vector3.Distance(ooiTrans.position, _avatarTransform.position);
                ooiDistance.Add(ooiDisToAvatar);
            }

        }
        int indexOfMinDisOoi = ooiDistance.IndexOf(ooiDistance.Min());
        Transform closestOOI = ooiTransform[indexOfMinDisOoi];
      
       return closestOOI;
        



    }

    
    IEnumerator CameraIdling(float IdleStart)
    {
        _camCamera.enabled = false;

     if (_IdleTimer < IdleStart+5)
     {
         
         SceneCam1.enabled = true;
         SceneCam2.enabled = false;
         FrontCam.enabled = false;
         
     }

     else if (_IdleTimer < IdleStart+11)
     {
         SceneCam2.enabled = true;
         SceneCam1.enabled = false;
         FrontCam.enabled = false;
         
     }

    else if (_IdleTimer <IdleStart+17)

     {
         FrontCam.enabled = true;
         SceneCam1.enabled = false;
         SceneCam2.enabled = false;
         
     }

     if (_IdleTimer >= IdleStart+17)
     {
         _IdleTimer = IdleStart;
     }

     yield return null;
    }



    #endregion
    
   
private enum CameraStates
{
    Manual,
    Automatic,
    Idle
}

}
