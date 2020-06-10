public float ROTATION; // [-PI, PI]
public int joystick_curvature = 0;  
private float joystick_rotation_change = 0.05;

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

private float getRotationFromMouse() {
  return map(mouseX, 0, width, 0, 10) % TWO_PI - PI;
}

private float getRotationFromJoystick() {
  // joystick_curvature data is obtained in serial port events in main class (Game)
  float change = 0;
  if (joystick_curvature > 515 || joystick_curvature < 500) 
    change = joystick_rotation_change * (joystick_curvature > 507  ? +1 : -1);  
  return (ROTATION + change + PI) % TWO_PI - PI; // make within range [-PI, PI] 
}

/*
other sensors...
 */

//Returns a pair of values -1 or 1 that represents the change of position of board in axes X and Z based on current rotation.
public int[] getWalkingDirection() {
    int mp, mr;
    if (ROTATION < -PI*3/4 || ROTATION > PI*3/4) {
        mp = -1;
        mr = 0;
    } else if (ROTATION < -PI/4) {
        mp = 0;
        mr = -1;
    } else if (ROTATION < PI/4) {
        mp = 1;
        mr = 0;
    } else {
        mp = 0;
        mr = 1;
    }
    return new int[] {mp, mr};
}
