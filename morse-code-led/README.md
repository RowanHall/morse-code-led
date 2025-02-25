# Morse Code LED Blinker

This project is an assembly language program for an Arduino-based system that converts text input into Morse code and blinks an LED accordingly. It demonstrates low-level programming skills, embedded system development, and real-time processing using AVR assembly.

## Features

- Converts plain text to Morse code.
- Uses an LED to blink Morse code for each letter.
- Supports the full English alphabet
- Implements timing control to distinguish dots, dashes, and spaces.

## Technologies Used

- **Assembly Language** (AVR ASM)
- **AVR Microcontroller** (ATmega series)
- **Atmel Studio 7.0**
- **Arduino Hardware** (Compatible with ATmega-based boards)

## How It Works

1. The user inputs a string of text.
2. The program translates each character into its Morse code equivalent.
3. The LED blinks in a pattern representing dots and dashes:
   - A **dot** (`.`) is a short blink.
   - A **dash** (`-`) is a longer blink.
   - Spaces between letters and words follow standard Morse timing.
4. The process continues until the full message is transmitted.

## Hardware Requirements

- Arduino board (ATmega-based)
- External LED (if not using built-in LED on pin 13)
- Resistor (220Ω recommended)

## Software Requirements

- Atmel Studio 7.0 or an equivalent AVR assembler
- USB cable for flashing the program onto the microcontroller

## Example Morse Code Blinks

| Character | Morse Code | LED Pattern                   |
| --------- | ---------- | ----------------------------- |
| A         | .-         | Short, Long                   |
| B         | -...       | Long, Short, Short, Short     |
| C         | -.-.       | Long, Short, Long, Short      |
| 1         | .----      | Short, Long, Long, Long, Long |

## Potential Enhancements

- Implement sound output alongside LED blinking.

## Author

Rowan Hall  
GitHub: [Your GitHub Profile](https://github.com/RowanHall)
