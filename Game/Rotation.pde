public float ROTATION; // [-PI, PI] 
int x_axis_last_value=500;


// read mouse input and return looking direction [-PI, PI]
public void updateRotation() {
  switch (control) {
  case 0:
    ROTATION = getRotationFromJoystick();
    break;
  case 1:
    ROTATION = getRotationFromMouse();
    break;
  }

}


private float getRotationFromJoystick() {
  if (arduino.get_Joystick_X_Value()>515 || arduino.get_Joystick_X_Value()<500) x_axis_last_value+= (arduino.get_Joystick_X_Value()>507 ) ? +7 : -7;
  reset_X_axis();
  return map(x_axis_last_value, 0, width, -PI, PI);
}

private float getRotationFromMouse() {
  x_axis_last_value=mouseX;
  reset_X_axis();
  return map(mouseX, 0, width, -PI, PI);
}


/*
other sensors...
 */


//Returns a pair of values -1 or 1 that represents the change of position of board in axes X and Z based on current rotation.
public int[] getWalkingDirection() {
  int mp, mr;
  if (x_axis_last_value>875 || x_axis_last_value<125 ) {
    mp = -1;
    mr = 0;
  } else if (x_axis_last_value>125 && x_axis_last_value<375) {
    mp = 0;
    mr = -1;
  } else if (x_axis_last_value>375 && x_axis_last_value<625) {
    mp = 1;
    mr = 0;
  } else {
    mp = 0;
    mr = 1;
  }
  return new int[] {mp, mr};
}


void reset_X_axis(){
    if (x_axis_last_value>1000) {
    x_axis_last_value=0;
  } else if (x_axis_last_value<0) {
    x_axis_last_value=1000;
  }
}
