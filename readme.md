# Robotic Arm Simulation (LOVE2D)

This project simulates a robotic arm using the LOVE2D framework. The arm consists of three segments with inverse kinematics to reach a target position. The ground object acts as a reference point.

## Features
- Forward and inverse kinematics for a 3-link robotic arm.
- Real-time visualization using LOVE2D.
- Adjustable learning rate and convergence tolerance.
- Randomized initial joint angles on reset.
- Simple interface with key controls.

## Installation
### Prerequisites
- [LOVE2D](https://love2d.org/) installed on your system.
- Clone or download this repository.

### Running the Simulation
1. Navigate to the project folder in the terminal.
2. Run the following command:
   ```sh
   love .
   ```

## Controls
- `ESC` → Exit the program.
- `R` → Reset the arm with random initial angles.

## Code Structure
- `main.lua` → Handles game loop and user interactions.
- `arm_2.lua` → Defines the robotic arm class.
- `ground.lua` → Defines the ground object.
- `class.lua` → Simple object-oriented programming helper.
- `push.lua` → Handles virtual resolution scaling.

## Configuration Parameters
The following parameters can be modified in `main.lua`:
- `TARGET = {x, y}` → Target position.
- `LENGTH = {l1, l2, l3}` → Lengths of the arm segments.
- `LEARNING_RATE` → Step size for the inverse kinematics algorithm.
- `MAX_ITERS` → Maximum iterations for solving inverse kinematics.
- `TOLERANCE` → Error tolerance for convergence.
- `THETA_VEL = {v1, v2, v3}` → Velocity of each joint.

## Dependencies
This project requires the following external files:
- `class.lua` (for OOP support in LOVE2D)
- `push.lua` (for resolution handling)
- `ground.lua` (ground object definition)
- `arm_2.lua` (robotic arm logic)

## Future Improvements
- Add collision detection for obstacles.
- Implement user-defined target positions via mouse click.
- Improve kinematics solver for smoother movement.
