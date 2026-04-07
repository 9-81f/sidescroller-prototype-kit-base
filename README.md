# Godot 2D Platformer Prototype Kit (v0.1.0)

**Stop re-inventing the wheel.** Every 2D prototype starts with the same two hurdles: a reliable character controller and seamless level transitions. This kit provides a solid foundation so you can skip the "boilerplate" and focus on crafting your game's unique features.

---

## 🧠 The Architecture (The "Why")
This kit uses a **Persistent Player Architecture** instead of the usual "change_scene_to_file()" approach:

* **Persistence:** The Player and UI live in a "Main" scene and are never deleted. We "transport" the player between levels, preserving stats and state.
* **Decoupled Loading:** Levels don't know about each other. They only communicate through a "Handshake" using **Markers** and **Resources**.
* **State-Driven Safety:** A Node-based **Finite State Machine (FSM)** ensures the player is "Freezed" during transitions to prevent physics glitches.

---

## 🚀 Quick Start: The 3-Step Handshake

### 0. Setting the Start Point
Before building, you can define where the game begins. 
* Open the **Main Scene** (`res://core/main/Main.tscn`).
* In the Inspector for `Main.gd`, locate the `starting_level` export variable.
* Slot in a `BaseLevelTransporter` resource to define the initial Level and Spawn Marker.

### 1. Level Creation
* Create a new `Node2D` scene in `res://game/levels/`.
* Attach the `BaseLevel.gd` script to the root node.
* **The Bounds:** Create a `BaseLevelSettings` resource. Input your level boundaries (Top, Left, Bottom, Right) as **positive values**. This ensures the camera respects your level edges.

### 2. Define Entry Points
* Place `Marker2D` nodes at every entrance (e.g., `WestGate`, `ElevatorExit`).
* **The Transporter:** Create a `BaseLevelTransporter` resource in `res://game/levels/resources/transporters/`. 
* **The Handshake:** In the resource, define the **Target Level** (the `.tscn` file) and the **Spawn Marker** (the name of the marker in that target level).

### 3. Activation & Loop
* Add a `CollisionTransportComponent` to your scene with a `CollisionShape2D` trigger.
* Slot your `BaseLevelTransporter` resource into the component.
* **Crucial:** To go "back and forth," repeat these steps in your **destination level**. Level A needs a transporter pointing to Level B, and Level B needs one pointing back to Level A.

---

## ✨ Movement & Feel (Modular Components)
This kit includes a fully-featured **Character Controller** with "Juices" that you can toggle on or off/opt-in or out.

### Tuning the Physics
All movement values are stored in **`BaseMovementSettings`** resources. You can create multiple resources (e.g., `HeavyMovement.tres`, `FastMovement.tres`) and swap them on the `MovementComponent` inspector.
* **Variable Jump Height:** Can be toggled on/off directly in the `BaseMovementSettings` resource.
* **Modular Features:** **Coyote Time** and **Jump Buffering** are separate components. Simply add or remove these nodes from the Player/Entity to opt-in or out of these features.

### Character & Animation
* Includes a pixel-art humanoid placeholder with animations for Idle, Run, Jump, Slide, and Crouch.
* **Custom Inputs:** Map your own `InputMap` actions by overriding these methods in the `Player` class:
  * `jump_input`, `jump_input_released`
  * `run_input`, `slide_input`, `crouch_input`, `stand_input`

---

## 🛠️ Advanced: Extensible State Machine
This kit uses a `BaseState` class that can be extended for any entity (Player, Enemies, NPCs).

### The "Wrapper State" Pattern
To get full **IDE Autocomplete** and avoid generic `CharacterBody2D` casting, follow the pattern used in `PlayerState.gd`:

1.  **Create a Wrapper:** Extend `BaseState` to create a specific class (e.g., `EnemyState`).
2.  **Cast the Entity:** Create a typed variable (e.g., `var enemy: Enemy`) and assign it in `_ready` by casting the base `entity`.
3.  **Inherit:** Create your specific states (e.g., `EnemyIdle`) by extending your wrapper (`EnemyState`).

---

## 📁 Project Structure
* **`res://core/`**: The Engine. Contains the `SceneLoader`, `BaseClasses`, and `EntityEnums`. 
    * *Note:* You can modify `EntityEnums.STATE` to add new states. Remember to use `register_state_key` in your new state's `_ready` function!
* **`res://game/`**: The Game. This is where your `Entities`, `Levels`, and `Shared` components live.

---

## 🏗️ Technical Summary
* **Guarded SceneLoader:** Managed transitions with built-in `CanvasLayer` fades and a "Gatekeeper" boolean to prevent concurrent scene loads.
* **Input Lock:** Automatic `FREEZED` state during transit to ensure player safety.
* **Resource-Based Data:** Use "Blueprints" (Resources) to define level and movement data without touching code.

---

## ⚠️ Requirements
* **Godot Version:** 4.2+ (Optimized for 4.5)
* **Language:** GDScript
