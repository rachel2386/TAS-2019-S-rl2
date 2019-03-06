using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    // Start is called before the first frame update
    private Rigidbody myRB;
    private float Speed= 50;
    
    void Start()
    {
        myRB = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        myRB.velocity = Vector3.right * Input.GetAxis("Horizontal") * Speed
                        + Vector3.forward * Input.GetAxis("Vertical") * Speed;
    }
}
