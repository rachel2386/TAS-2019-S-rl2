using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PersonAnimationControls : MonoBehaviour
{
    Animator myAnim;
    // Start is called before the first frame update
    private float IdleTime = 0f;
    private float moveTime = 0f;
    [Range(0.001f, 3f)] public float walkCycleTime;
    [Range(0.001f, 10f)] public float moveMagnitude;
    [Range(0.00f, 1f)] public float OverallMovementBlendMeter;
    void Start()
    {
        myAnim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        IdleTime += Time.deltaTime;
        myAnim.SetFloat("IdleTime", Mathf.Abs(Mathf.Sin(IdleTime)));
        if(Input.GetKey(KeyCode.W))
            myAnim.SetBool("Moving", true);
        else
            myAnim.SetBool("Moving", false);

        if (myAnim.GetBool("Moving"))
        {
            walkCycleTime = 1f-(0.5f *OverallMovementBlendMeter);
            moveMagnitude = 0.25f + (0.75f * OverallMovementBlendMeter);
            moveTime += Mathf.PI * 2 *Time.deltaTime / walkCycleTime;
            myAnim.SetFloat("WalkBlendX", Mathf.Sin(moveTime) * moveMagnitude);
            myAnim.SetFloat("WalkBlendY", Mathf.Cos(moveTime) * moveMagnitude);
        }

    }
}
