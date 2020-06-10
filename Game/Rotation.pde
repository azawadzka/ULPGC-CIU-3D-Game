public float ROTATION; // [-PI, PI]

// read mouse input and return looking direction [-PI, PI]
public void updateRotation() {
  ROTATION = getRotationFromMouse();
}

private float getRotationFromMouse() {
  return map(mouseX, 0, width, 0, 10) % TWO_PI - PI;
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
