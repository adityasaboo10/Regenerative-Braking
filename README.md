# Regenerative Braking System 🔋⚡

> Capturing kinetic energy — converting deceleration into usable power

![FPGA](https://img.shields.io/badge/Control-FPGA-blue) ![BLDC](https://img.shields.io/badge/Motor-BLDC-green) ![Simulation](https://img.shields.io/badge/Simulation-MATLAB%2FSimulink-orange) ![Status](https://img.shields.io/badge/Status-Proof%20of%20Concept-yellow)

---

## 👥 Team Members

| Name | Roll Number |
|------|-------------|
| Digvijay Singh Pundir | 240002024 |
| Aditya Sabooo | 240002006 |
| Abhishek Mehta | 240002003 |
| Devansh Chaudhary | 240002023 |

---

## 📌 Overview

This project implements a **Kinetic Energy Recovery System (KERS)** for electric vehicles. During braking, kinetic energy that would otherwise be lost as heat is captured and converted back into usable electrical energy — extending vehicle range without increasing battery size.

**Best suited for:** Urban stop-and-go traffic where frequent braking events maximize energy recovery opportunities.

---

## 🧠 System Architecture

### Module 1 — FPGA Control Logic
The FPGA serves as the brain of the system:
- **High-Speed Parallel Processing** — handles complex control logic in real time
- **Digital PWM Generation** — precise motor control in both motoring and generating modes
- **BLDC Motor Management** — efficient operation across all driving conditions

The FPGA continuously monitors Hall effect sensor readings to determine the precise moment to engage energy recovery.

### Module 2 — Circuit Design (The Energy Switch)

| Mode | Power Flow | Description |
|------|-----------|-------------|
| ⚡ Motoring | Battery → Motor | Power drives the wheels |
| 🔄 Regenerative | Motor → Capacitor | Back EMF redirected to storage |

The circuit uses a **three-phase bridge inverter** with freewheeling diodes that provide safe current paths during switch transitions, preventing voltage spikes.

---

## ⚙️ How It Works
1. **Hall effect sensors** track rotor position in real time
2. **FPGA** processes signals and determines braking state (DRIVE / COAST / SOFT_BRAKE / HARD_BRAKE)
3. **PWM Inverter** switches between motoring and regenerative modes
4. **Supercapacitor** absorbs voltage spikes during regeneration and stores recovered energy

### BLDC Drive Components

| Component | Role |
|-----------|------|
| Torque Pedal Signal | Converts accelerator/brake input into an electrical signal |
| Speed Controller | Processes pedal signal + motor feedback to calculate speed & torque demands |
| Decoder & Hall Effect Sensor | Interprets sensor readings to determine instantaneous rotor position |
| PWM Inverter | Converts DC to AC for motoring, or channels regen energy back to storage |

---

## 🧪 Simulation (MATLAB / Simulink)

The system was modeled and validated in **MATLAB Simulink**, including:
- BLDC Motor Drive model
- Hall Sensor Decoder
- Current Controller
- Back EMF waveform analysis across all three phases (e_a, e_b, e_c)

### FPGA FSM Control Logic — Test Results

| Test | Scenario | Outcome |
|------|----------|---------|
| TEST 2 | Constant speed + accel pressed | ✅ DRIVE — state=0 ctrl=0 |
| TEST 3 | No pedal + wheel stopped | ✅ COAST — state=1 ctrl=1 |
| TEST 4 | Brake + moderate deceleration | ✅ SOFT_BRAKE — state=2 ctrl=2 |
| TEST 5 | Sudden stop | ✅ HARD_BRAKE — state=3 ctrl=3 |

### FPGA Signal Processing Pipeline
The timing cycle shows encoder sampling, velocity calculation, acceleration estimation, filtering, and FSM output generation across clock cycles.

---

## 🔌 Braking Scenarios

| Scenario | Behavior |
|----------|----------|
| Gentle Braking | Regenerative braking handles deceleration, maximum energy recovery |
| Hard Braking | Friction braking takes over to ensure safety; regen assists where possible |
| Smooth Handover | FPGA blends both modes seamlessly based on deceleration magnitude |

---

## ⚠️ Hardware Implementation & Known Drawbacks

The hardware prototype served as a **valid proof of concept**, but exposed two key limitations:

### 1. Relay Switching Speed Limitation
Conventional SPDT relays switch in milliseconds — too slow to capture the brief voltage spike that occurs during regeneration. The relay could not respond quickly enough, making it unsuitable for this application.

**Fix:** Replace with high-speed MOSFETs or IGBTs.

### 2. Limited Regeneration Duration
Without a flywheel to preserve motor inertia, the regenerative motion was very short-lived, limiting how much braking energy could be transferred back into the circuit.

**Fix:** Integrate a flywheel or increase rotor inertia mechanically.

---

## 🔮 Future Improvements

- [ ] Replace relays with high-speed MOSFETs or IGBTs for faster switching
- [ ] Add a flywheel to extend regenerative braking duration
- [ ] Integrate a bidirectional DC-DC converter for better energy flow control
- [ ] Implement adaptive brake blending based on real-time deceleration magnitude
- [ ] Scale to a real two-wheeler or full EV platform
- [ ] Add battery state-of-charge (SoC) monitoring to regulate regen intensity

---

## 📚 References

- *"An FPGA based Regenerative Braking System of Electric Vehicle Driven by BLDC Motor"*

---
