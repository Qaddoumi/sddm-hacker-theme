> **⚠️ This theme is currently not working. I am actively working on fixing it.**

# Hacker SDDM Theme
This is a hacker-style SDDM theme with a dark background, neon green text, and a matrix digital rain effect.


### Installation Instructions


**Preview the Theme**:
   - Run the following command to test the theme without logging out:
     ```bash
     sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/hacker-theme
     ```

## Notes
- The theme is designed for 1080p but should scale to other resolutions.
- The matrix effect is lightweight but can be disabled by removing the `Canvas` and `Timer` components in `Main.qml` if performance is an issue.
- Ensure you have the necessary Qt6 dependencies (requires `qt6-declarative`) installed for QML rendering.
- For a more immersive experience, you can replace `background.jpg` with an animated wallpaper (requires `qt6-multimedia`).

# Install

```bash
bash <(curl -sL https://raw.githubusercontent.com/Qaddoumi/sddm-hacker-theme/main/install.sh)
```
