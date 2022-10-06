#include <simplecpp>
#include "shooter.h"
#include "bubble.h"
#include <cmath>

/* Simulation Vars */
const double STEP_TIME = 0.02;

/* Game Vars */
const int LEFT_MARGIN = 70;
const int TOP_MARGIN = 20;
const int BOTTOM_MARGIN = (
PLAY_Y_HEIGHT+TOP_MARGIN);


void move_bullets(vector<Bullet> &bullets){
    // move all bullets
    for(unsigned int i=0; i<bullets.size(); i++){
        if(!bullets[i].nextStep(STEP_TIME)){
            bullets.erase(bullets.begin()+i);
        }
    }
}

void move_bubbles(vector<Bubble> &bubbles){
    // move all bubbles
    for (unsigned int i=0; i < bubbles.size(); i++)
    {
        bubbles[i].nextStep(STEP_TIME);
    }
}

vector<Bubble> create_bubbles()
{
    // create initial bubbles in the game
    vector<Bubble> bubbles;
    bubbles.push_back(Bubble(WINDOW_X/2.0, BUBBLE_START_Y, BUBBLE_DEFAULT_RADIUS, -BUBBLE_DEFAULT_VX,-BUBBLE_DEFAULT_VY, COLOR(255,105,180)));
    bubbles.push_back(Bubble(WINDOW_X/4.0, BUBBLE_START_Y, BUBBLE_DEFAULT_RADIUS, BUBBLE_DEFAULT_VX, BUBBLE_DEFAULT_VY, COLOR(255,105,180)));
    return bubbles;
}


int main()
{
    initCanvas("Bubble Trouble", WINDOW_X, WINDOW_Y);

    Line b1(0, PLAY_Y_HEIGHT, WINDOW_X, PLAY_Y_HEIGHT);
    b1.setColor(COLOR(0, 0, 255));

    string msg_cmd("Cmd: _");
    Text charPressed(LEFT_MARGIN, BOTTOM_MARGIN, msg_cmd);

    //health
    string health("Health: _");
    int healthcount=3;
    Text healthword(450,BOTTOM_MARGIN,health);

    //score
    string score("Score: _");
    int scorecount=0;
    Text scoreword(250,BOTTOM_MARGIN,score);

    // Intialize the shooter
    Shooter shooter(SHOOTER_START_X, SHOOTER_START_Y, SHOOTER_VX);


    //Time
    string timer("Time: __/50");
    double time=0;
    Text timeword(LEFT_MARGIN,10,timer);

    // Initialize the bubbles
    vector<Bubble> bubbles = create_bubbles();

    // Initialize the bullets (empty)
    vector<Bullet> bullets;

    XEvent event;

    // Main game loop
    while (true)
    {   //health
        char H=healthcount+48;            //48 added because it is ASCII system
        health[health.length()-1]=H;
        healthword.setMessage(health);

        //score
        char S=scorecount+48;              //48 added due to ASCII system
        score[score.length()-1]=S;
        scoreword.setMessage(score);

        //Timer
        int T=time;                           //time is of double data type while we want only integer value so we fist convert it into integer
        char T10=(T/10)+48;                   //number at 10th's place(48 added to convert to ASCII
        char T1=(T%10)+48;                    //number at unit's place(48 added to convert to ASCII
        timer[timer.length()-5]=T10;
        timer[timer.length()-4]=T1;
        timeword.setMessage(timer);

        bool pendingEvent = checkEvent(event);
        if (pendingEvent)
        {
            // Get the key pressed
            char c = charFromEvent(event);
            msg_cmd[msg_cmd.length() - 1] = c;
            charPressed.setMessage(msg_cmd);

            // Update the shooter
            if(c == 'a')
                shooter.move(STEP_TIME, true);
            else if(c == 'd')
                shooter.move(STEP_TIME, false);
            else if(c == 'w')
                bullets.push_back(shooter.shoot());
            else if(c == 'q')
                return 0;
        }

        // Update the bubbles
        move_bubbles(bubbles);

        // Update the bullets
        move_bullets(bullets);


        //disappearing bullet and bubble when they collide
            for (unsigned int i=0; i < bullets.size(); i++){
                   for (unsigned int j=0; j < bubbles.size(); j++){                        //for ith bullet and jth bubble
                      double distx=bullets[i].get_center_x() - bubbles[j].get_center_x(); //distance between x co-ordinates of the centre
                      double disty=bullets[i].get_center_y() - bubbles[j].get_center_y(); //distance between y co-ordinates of the centre
                      double dist=sqrt(pow(distx,2)+pow(disty,2));                        //distance between centres
                      if(dist<bubbles[j].get_radius()+bullets[i].get_width() ||
                         dist<bubbles[j].get_radius()+bullets[i].get_height()
                         )                                                        //collision means distance between centres in less than radius of bubble +width or height of bullet
                         {scorecount++;
                         if(bubbles[j].radius==BUBBLE_DEFAULT_RADIUS) {    bubbles.push_back(Bubble(bubbles[j].get_center_x(),bubbles[j].get_center_y(), BUBBLE_DEFAULT_RADIUS/2,bubbles[j].get_vx(),bubbles[j].get_vy(), COLOR(255,105,180)));
                                                                             bubbles.push_back(Bubble(bubbles[j].get_center_x(),bubbles[j].get_center_y(), BUBBLE_DEFAULT_RADIUS/2,-bubbles[j].get_vx(),bubbles[j].get_vy(), COLOR(255,105,180)));
                                                                        //we splitted big buuble in two small ones
                                                                      }
                         bullets.erase(bullets.begin()+i);
                         bubbles.erase(bubbles.begin()+j);
                         }
                   }
             }
        if(bubbles.size() == 0) {Text t(250,250,"Congratulations!");   //game ends with success if all bubbles eliminated
                                 Text scorecounter(250,BOTTOM_MARGIN,"Score: 6");
                                t.setColor(COLOR(0,255,0));
                                wait(5);return 0;}
        for (unsigned int i=0; i < bubbles.size(); i++){
         double xi=bubbles[i].get_center_x();
         double yi=bubbles[i].get_center_y();

         double distx=xi- shooter.get_head_center_x();
         double disty=yi- shooter.get_head_center_y();
         double distxy=sqrt(pow(distx,2)+pow(disty,2));                    //distance between centre of bubble and head of shooter
         double dist1=xi- shooter.get_body_center_x();
         double dist2=yi- shooter.get_body_center_y();
         double dist=sqrt(pow(dist1,2)+pow(dist2,2));                      //distance between bubble and body
         if( distxy< bubbles[i].get_radius()+shooter.get_head_radius()
            || dist< bubbles[i].get_radius()+shooter.get_body_width()
            )
            {
            healthcount--;
         if(healthcount==0) { Text t(250,250,"GAME OVER");
            Text healthcounter(450, BOTTOM_MARGIN, "Health: 0");
            shooter.changecolor(COLOR(255,0,0));
                   //game ends with failure if bubble touches shooter 3rd time
            t.setColor(COLOR(0,255,0));wait(5);return 0;}

        repeat(25)           //now shooter is frozen for some time since it lost it's one health. Meanwhile bubbles and bullets move and timer runs
              {   // move bubbles and bullets
                  shooter.changecolor(COLOR(255,0,0));
                  move_bubbles(bubbles);
                  move_bullets(bullets);
                  time += STEP_TIME;

                  //Timer should also run in parralel when shooter is frozen for some time
                  int T=time;
                  char T10=(T/10)+48;
                  char T1=(T%10)+48;
                  timer[timer.length()-5]=T10;
                  timer[timer.length()-4]=T1;
                  timeword.setMessage(timer);
                  time += 3*STEP_TIME;

                  wait(STEP_TIME);
              }
            shooter.changecolor(COLOR(0,255,0));
            }
            }




        time += 3*STEP_TIME;                                      // multiplied 3 so that timer approximatly runs like second clock

        if(time>50.50) {Text t(250,250,"GAME OVER");              //at 50 it is over, Here 50.50 wriiten so that timer shows 50 first and then game over occrus

                         t.setColor(COLOR(0,255,0));wait(5);return 0;
                      }
        wait(STEP_TIME);

    }
}
