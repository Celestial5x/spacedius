# Spacedius

Spacedius is 2D side-scrolling shoot-em-up remake of Gradius.

# Instructions

## Title Screen
Use the **Up** or **Down** arrow keys to navigate between the **Start** or **High Scores** and press **Enter** or **Return** to select.

## In-Game
Use the **Arrow Keys** to navigate the ship.

Press or hold the **Space Bar** to shoot.

Press **P** to pause the game.

Press **Esc** or quit the game.

# Documentation
## States 
### Base State
Used as the base class for all of our states.
### Title Screen State
Used as the starting screen of the game and transitions to either the Countdown State or High Scores State.
### Countdown State
Used to countdown before the game begins and transitions to the Play State.
### Play State
The Play State is the bulk of the game where the player ship interacts with other classes.  Powerups drop with a random chance after defeating enemy ships.  Timers are used to spawn enemy ships, enemy bullets and asteroids at random intervals.  If the player ship collides with enemy ships, bullets, or asteroids, then the game is over and transitions to the Game Over state.
### Game Over State
Used to display the final score after a game over and transitions to the Enter High Score State or back ot the Title Screen State.
### Enter High Score State
Used to enter a new high score with player input in the form of three characters.
## Classes
### Asteroid Class
Represents asteroids that act as obstacles in the game which blocks player bullets.  Asteroids can be destroyed by missiles.  If the player ship collides with an asteroid then the game is over.  This provides a challenge to the player that restricts player bullets and navigation but can be destroyed if missile power up is obtained.
### Boss Class
Represents the boss that spawns after the player score reaches a threshold which has health that scales with the level.
### Bullet Class
Represents player and enemy bullets that does damage when colliding with other ships.
### constants Class
Sets global constants used in the game.
### Missile Class
Represents missile powerup for the player ship and/or option which aims diagonally and can damage enemy ships.  Can also be used to destroy asteroids.
### Option Class
Represents option powerup for the player ship that mirrors the player bullets (and missiles).  The option(s) rotate equally spaced around the player ship and can block enemy bullets when collided.  The number of options is restricted to the current level up to a maximum of 4.
### Plane Class
Represents the enemy ships that spawn from the right edge of the screen.  These enemy ships shoot bullets toward the player ship.
### Player Class
Represents the ship which the player controls in the game by navigating and shooting bullets and/or missiles.
### Powerup Class
Represents powerups that spawn after enemy ships are destroyed at a random chance.  The player can obtain either the missile or option powerup.
### Progress Bar Class
Renders the boss health bar when the boss is spawned and decreases as the boss takes damage.
### State Machine Class
Code taken and edited from lessons in http://howtomakeanrpg.com.
### Util Class
Helper functions.
