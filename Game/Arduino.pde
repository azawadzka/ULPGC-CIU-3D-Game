import processing.serial.*;



public class Arduino {

  int [] buffer= new int[5] ; // INPUT VARIABLES
  public Serial arduino_Serial; //Conexion al Serial


  public Arduino(Serial arduino_serial) {
    arduino_Serial= arduino_serial;
  }


  /*
  * Return the value of X axis 
   */
  public int get_Joystick_X_Value() {
    return buffer[1];
  }

  /*
  * Return the value of Y axis 
   */
  public int get_Joystick_Y_Value() {
    return buffer[0];
  }

  /*
  * Return 1 = pressed
   * Return 0 = not pressed
   */
  public int get_right_Button_Value() {
    return buffer[2];
  }


  /*
  * Return 1 = pressed
   * Return 0 = not pressed
   */
  public int get_pick_Button_Value() {
    return buffer[3];
  }


  /*
  * Return 1 = pressed
   * Return 0 = not pressed
   */
  public int get_Pause_Button_Value() {
    return buffer[4];
  }

  /*
   *  Serial Events
   */

  /*
  * Read the serial port
   */
  void serial_Event_Manager(Serial arduinoSerial) {
    arduinoSerial.bufferUntil('\n');
    String aux=arduinoSerial.readStringUntil('\n'); //es NECESARIO crear una variable auxiliar, lo explico en otro momento xD
    if (aux != null)buffer= int(split(aux, "-"));

    // EVENTS CASES
    if (buffer[0]>525 || buffer[0]<514 )Joystick_Y_axis_event();
    if (buffer[2]==1)rightButtonClicked();
    if (buffer[3]==1)leftButtonClicked();
    if (buffer[4]==1)pause_Button_Clicked();
  }




  void rightButtonClicked() {
    if (control==0) {
      if (status) {
        switch(menu.options) {

        case 0:
          status=false;
          menu.intro.stop();
          textFont(createFont("SansSerif", 16));
          break;
        case 1:
          menu.set_controllers_display(true);
          menu.set_credits_display(false);
          break;
        case 2:
          menu.set_controllers_display(false);
          menu.set_credits_display(true);
          break;
        }
      } else {
        if (!game_over_screen) {
          if (player.request_move()) {
            arrow.cancel_false_click();
            steps.play();
            if (!check_collision_player_monster()) monster.request_move();
          } else {
            arrow.set_false_click();
          }
        }
      }
    }
  }




  void leftButtonClicked() {
    if (control==0) {

      if (status) {
        if (menu.get_controllers_display()) {
          menu.set_controllers_display(false);
        } else if (menu.get_credits_display()) {
          menu.set_credits_display(false);
        }
      } else {

        if (room.getItem() != null && room.getItem().getPickable()) {
          Obstacle item = room.getItem();
          item.setPickable(false);
          player.inventory.addItem(item);
          board.remove_from_board(room.item_p, room.item_r);
        }

        if (  room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
          board.remove_from_board(room.item_p, room.item_r);    
          player.inventory.removeItem(room.getItem());
          player.inventory.display();
        }
      }
    }
  }

  //TO DO
  void pause_Button_Clicked() {
    if (control==0) {
      if (!pause) {
        pause = true;
      } else {
        pause = false;
      }
    }
  }

  void Joystick_Y_axis_event() {
    if (control==0) {
      if (status && !menu.get_controllers_display() && !menu.get_credits_display()) {

        //UP
        if (buffer[0]<514) {
          menu.options--;
          if (menu.options<0)menu.options=2;
        } else if (buffer[0]>525) {   //DOWN
          menu.options++;
          if (menu.options>2)menu.options=0;
        }
      } else if (menu.get_controllers_display() || pause) {

        //UP
        if (buffer[0]<100) {
          control=0;
        } else if (buffer[0]>1000) {   //DOWN
          control=1;
        }
      }
    }
  }
} 
