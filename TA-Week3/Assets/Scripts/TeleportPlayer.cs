using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportPlayer : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform teleportPos;
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Debug.Log("triggered!");
            other.gameObject.transform.position = teleportPos.position;
        }
    }
}
