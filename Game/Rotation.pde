public float ROTATION; // [-PI, PI]
public float TORCH_VERTICAL_POINT; // [-300, 0]  
private int x_axis_last_value = 0;

public void updateRotation() {
  switch (control) {
  case 0:
    ROTATION = getRotationFromJoystick();
    TORCH_VERTICAL_POINT = get_torch_vertical_point_from_Joy();
    break;
  case 1:
    ROTATION = getRotationFromMouse();
    TORCH_VERTICAL_POINT = get_torch_vertical_point_from_mouse(); //to be changed
    break;
  }
}

private float getRotationFromMouse() {
  x_axis_last_value=mouseX;
  reset_X_axis();
  
  return map(mouseX, 0, width, -PI, PI);
}

private float getRotationFromJoystick() {
  if (arduino.get_Joystick_X_Value()>515 || arduino.get_Joystick_X_Value()<500) x_axis_last_value+= (arduino.get_Joystick_X_Value()>507 ) ? +7 : -7;
  reset_X_axis();
  return map(x_axis_last_value, 0, width, -PI, PI);
}

private float get_torch_vertical_point_from_mouse() {
  return map(mouseY, 0, height, -300, 00);
}

private float get_torch_vertical_point_from_Joy() {
  return map(arduino.get_Joystick_Y_Value(), 0, height, -300, 00);
}

/*
other sensors...
 */

//Returns a pair of values -1 or 1 that represents the change of position of board in axes X and Z based on current rotation.
public int[] getWalkingDirection() {
  int mp, mr;
      int media= width/4;
    
    if (x_axis_last_value>width-(media/2) || x_axis_last_value<media/2 ) {
      mp = -1;
      mr = 0;
    } else if (x_axis_last_value>media/2 && x_axis_last_value<(media/2)*3) {
      mp = 0;
      mr = -1;
    } else if (x_axis_last_value>(media/2)*3 && x_axis_last_value<(media/2)*5) {
      mp = 1;
      mr = 0;
    } else {
      mp = 0;
      mr = 1;
    }

  

  return new int[] {mp, mr};
}

void reset_X_axis() {
  
    if (x_axis_last_value>=width) {
      x_axis_last_value=0;
    } else if (x_axis_last_value<0) {
      x_axis_last_value=1000;
    }
  }
