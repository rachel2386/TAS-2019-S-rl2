using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraMovement : MonoBehaviour
{
    private Rigidbody myRB;
    public bool MouseLook;

    [Range(3, 30)] public float Speed;
    [Range(10, 100)] public float MouseSensitivity;
    // Start is called before the first frame update
    void Start()
    {
        myRB = GetComponent<Rigidbody>();
        Cursor.lockState = CursorLockMode.None;

    }

    // Update is called once per frame
    void Update()
    {
        myRB.velocity = transform.right * Input.GetAxis("Horizontal") * Speed 
                                        + transform.forward * Input.GetAxis("Vertical") * Speed;

        if (MouseLook)
            transform.rotation = Quaternion.Euler(-Input.mousePosition.y *0.5f,
                Input.mousePosition.x * 0.5f, 0) ;
    }
}
