# Regenerative Braking System 🔋⚡

> Capturing kinetic energy — converting deceleration into usable power

![FPGA](https://img.shields.io/badge/Control-FPGA-blue) ![BLDC](https://img.shields.io/badge/Motor-BLDC-green) ![Simulation](https://img.shields.io/badge/Simulation-MATLAB%2FSimulink-orange) ![Status](https://img.shields.io/badge/Status-Proof%20of%20Concept-yellow)

**[📥 View / Download Project Presentation (PPT)](./Regenerative-Braking.pdf)**

![Hardware Circuit Diagram]("C:\Users\adisa\Downloads\circuit.jpeg")
*Fig 1: Hardware Proof-of-Concept wiring featuring a Basys 3 FPGA, BLDC motor driver, energy storage capacitors, and electromechanical relay switching.*

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

This project implements a **Kinetic Energy Recovery System (KERS)** designed for electric vehicles. During braking, kinetic energy that is traditionally lost as heat is captured via motor back-EMF and converted back into usable electrical energy. This system extends vehicle range without necessitating a larger battery capacity.

**Best suited for:** Urban stop-and-go traffic where frequent deceleration events maximize energy recovery opportunities.

---

## 🧠 System Architecture

### Module 1 — FPGA Control Logic (Basys 3)
The FPGA serves as the central processing unit for the system, offering deterministic, nanosecond-level response times:
- **High-Speed Parallel Processing:** Handles complex finite state machine (FSM) logic in real-time.
- **Digital PWM Generation:** Provides precise duty-cycle control for motor speed and braking torque.
- **Rotor Position Tracking:** Continuously polls Hall effect sensors to determine exact rotor alignment for optimal phase commutation.

### Module 2 — Power Electronics & Energy Routing
The energy routing circuit toggles the flow of current based on the vehicle's state:

| Mode | Power Flow | Operational Logic |
|------|-----------|-------------|
| ⚡ **Motoring** | Battery → Motor | Inverter switches in standard 6-step commutation to drive the wheels. |
| 🔄 **Regenerating** | Motor → Capacitor/Battery | Inverter switching is modulated to act as a boost converter, pushing back-EMF into the storage medium. |

---

## ⚙️ How It Works

1. **Sensing:** Hall effect sensors track the BLDC rotor position and compute angular velocity.
2. **Decision Matrix:** The FPGA processes pedal/brake inputs alongside current velocity to determine the operational state (Drive, Coast, Soft Brake, Hard Brake).
3. **Actuation:** The motor driver adjusts the PWM duty cycle. During regeneration, the kinetic energy drives the motor as a generator.
4. **Storage:** A supercapacitor bank absorbs initial transient voltage spikes, protecting the battery and storing the rapid influx of recovered energy.

### FPGA Finite State Machine (FSM) Logic

The core logic has been refined into a 4-state machine to ensure smooth transitions between acceleration and deceleration:

| State | Scenario | Motor Driver Action | Outcome |
|:---:|----------|---------|---------|
| `00` | **DRIVE** (Accel pressed) | Forward PWM applied | Vehicle accelerates; draws current from battery. |
| `01` | **COAST** (No pedal input) | All high-side switches OFF | Motor freewheels; zero power consumed, minimal drag. |
| `10` | **SOFT_BRAKE** (Gentle brake) | Regen active (Reverse PWM/Boost) | Kinetic energy charges capacitors; moderate deceleration. |
| `11` | **HARD_BRAKE** (Sudden stop) | Dynamic braking / Friction combo | Motor windings shorted for maximum stopping force; friction brakes engaged. |

---

## 🧪 Simulation (MATLAB / Simulink)

Before hardware deployment, the system was mathematically modeled and validated in **MATLAB Simulink**. The simulation focused on:
- BLDC Motor Drive characteristics under varying loads.
- Hall Sensor Decoding and Commutation logic.
- Back-EMF waveform analysis across all three phases ($e_a, e_b, e_c$).
- Current controller stability during the transition from motoring to generating.

---

## ⚠️ Hardware Implementation & Known Limitations

The hardware prototype (pictured above) successfully validated the logic and state transitions. However, utilizing physical relays for power routing exposed significant mechanical limitations:

### 1. Relay Switching Speed Bottleneck
**Issue:** The proof-of-concept utilizes standard electromechanical relays to switch between the battery and the capacitor bank. Relays have a switching latency in the milliseconds, which is vastly too slow to capture high-frequency regenerative voltage spikes effectively.
**Resolution:** The production design must replace mechanical relays with solid-state switches (High-speed MOSFETs or IGBTs) configured in an H-bridge or 3-phase inverter setup.

### 2. Lack of Inertial Mass
**Issue:** Without a physical flywheel or the actual mass of a vehicle attached to the motor, the rotor's inertia was too low. The motor stopped almost instantly when braking was applied, severely limiting the duration of the regeneration window.
**Resolution:** For bench-testing, integrating a weighted flywheel to the motor shaft will artificially simulate vehicle mass and extend the regenerative braking duration for better data collection.

---

## 🔮 Future Improvements

- [ ] **Solid-State Upgrades:** Replace electromechanical relays with high-speed MOSFETs/IGBTs for instantaneous, bounce-free switching.
- [ ] **Mechanical Simulation:** Add a flywheel to the BLDC motor to accurately simulate vehicle inertia and prolong the regen window.
- [ ] **Bidirectional DC-DC Converter:** Implement a buck-boost converter to safely step up the back-EMF voltage so it can charge the battery even at low motor speeds.
- [ ] **Adaptive Brake Blending:** Program the FPGA to dynamically balance regenerative braking torque with a mechanical friction brake servo based on the speed of brake pedal depression.
- [ ] **SoC Integration:** Add battery State-of-Charge (SoC) monitoring to prevent overcharging by automatically disabling regen when the battery is at 100%.

---

## 📚 References

- *"An FPGA based Regenerative Braking System of Electric Vehicle Driven by BLDC Motor"*
