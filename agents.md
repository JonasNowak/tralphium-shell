# Tralphium Agent Guidelines

This document outlines the purpose, ambitions, and scope of the **Tralphium** project. AI agents working on this repository must read and adhere to these guidelines to ensure the project stays true to its core vision.

## 1. Purpose
The primary goal of Tralphium is to build a custom, fully functional desktop shell/GUI on top of **Mango WM**. 
- AI agents are tasked with the active implementation and maintenance of this shell. 
- The target state is a complete, stable, and daily-drivable graphical user interface tailored for the user.

## 2. Ambitions
Tralphium aims to compose a **fully featured yet lightweight GUI** that integrates seamlessly with Mango WM. 
- It should provide all the necessary desktop components (e.g., application launchers, taskbars, status areas) without unnecessary bloat.
- The project is not just a toy or a proof of concept; it is intended to reach a "finished" and polished state.

## 3. Scope & Philosophy
All code written, architectures proposed, and features implemented must strictly adhere to the following principles:
- **Lightweight:** Resource usage should be kept to a minimum. Avoid heavy dependencies or over-engineered solutions.
- **KISS Philosophy (Keep It Simple, Stupid):** Simplicity is paramount. Code should be readable, straightforward, and maintainable. 
- **Wayland/Quickshell Native:** The shell is built for Wayland using QML and Quickshell. Work within the constraints and idioms of these technologies natively, avoiding X11-specific workarounds.
- **Modularity:** Keep components logically separated (e.g., UI components in `components/`, assets in `assets/`, theme definitions in `themes/`) to ensure the codebase remains clean and simple to navigate.
