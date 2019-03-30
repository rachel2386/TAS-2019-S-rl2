using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playAudio : MonoBehaviour
{
  public void PlayAudio()
  {
    AudioSource myAudio = GetComponent<AudioSource>();
    
    if(!myAudio.isPlaying)
      myAudio.Play();
  }
}
