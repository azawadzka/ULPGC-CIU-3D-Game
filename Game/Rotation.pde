public float ROTATION; // [-PI, PI]
int angulo;  



// read mouse input and return looking direction [-PI, PI]

//-----------------------------------------------------NO ES NECESARIO-------------------------------
public void updateRotation() {
  ROTATION = getRotation();
}

//-------------------------------------------------------------------------------------------------------------------



/* ACTUALMENTE SUSTITUIDO,   BORRAMOS????
 private float getRotationFromMouse() {
 return map(mouseX, 0, width, -PI, PI);
 
 }*/



private float getRotation() {
  switch(control) {
  case 0:
    if (angulo>515 || angulo<500) joystickX+= (angulo>507 ) ? +7 : -7;
    break;
  case 1: 
    joystickX=mouseX;
  }
  if (joystickX>1000) {
    joystickX=0;
  } else if (joystickX<0) {
    joystickX=1000;
  }
  return map(joystickX, 0, width, -PI, PI);
}
/*
other sensors...
 */


//Returns a pair of values -1 or 1 that represents the change of position of board in axes X and Z based on current rotation.
public int[] getWalkingDirection() {
  int mp, mr;

  if (joystickX>875 || joystickX<125 ) {
    mp = -1;
    mr = 0;
  } else if (joystickX>125 && joystickX<375) {
    mp = 0;
    mr = -1;
  } else if (joystickX>375 && joystickX<625) {
    mp = 1;
    mr = 0;
  } else {
    mp = 0;
    mr = 1;
  }
  return new int[] {mp, mr};
}
