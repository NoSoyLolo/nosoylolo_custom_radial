# nosoylolo_custom_radial

A simple and customizable radial menu script for **FiveM** that allows players to configure their own custom command shortcuts using the `ox_lib` radial menu.

Each player's configured settings are saved locally on their client via **KVP** (`GetResourceKvpString` / `SetResourceKvp`), ensuring their custom setups persist across sessions and server restarts.

## Dependencies

- `ox_lib`

Start dependencies first, then add to `server.cfg`:

```cfg
ensure ox_lib
ensure nosoylolo_custom_radial
```

Configure settings in `config.lua` and restart this resource for changes to take effect.

## Configuration (`config.lua`)

The `config.lua` file allows you to adjust the basic parameters of the script:

```lua
Config = {}

-- Command to open the slot configuration menu
Config.OpenSettingsCommand = 'radialconfig'

-- Maximum number of available slots in the radial menu
Config.MaxSlots = 6
```

## How It Works

### Player Persistence & Execution

Player preferences are stored on the client side using Key-Value Pairs (KVP). When a player logs in, the script reads these stored entries to populate their custom items in the `ox_lib` radial menu.

- **No slash required:** If a user includes a leading `/` when entering a command (e.g., `/repair`), the script automatically strips it out before saving.
- **Empty slots:** Unconfigured slots show a `(Vacío)` status in the radial menu. If a player triggers an empty slot, a chat notification prompts them to run the configuration command (`/radialconfig`).

## Player Guide

### Configuring a Slot

1. Open your chat box and run the configuration command (default: `/radialconfig`).
2. Select the slot you want to edit from the context menu.
3. Fill in the fields in the input dialog:
   - **Slot Name:** Descriptive label (e.g., `Repair`, `Dance`, `Heal`).
   - **Command:** The command to execute without the leading `/` (e.g., `repair`, `e dance`, `heal`).
   - **Icon Color:** Choose a custom color for the slot's icon.
4. Click **Submit** to save your settings. The radial menu will update instantly.

### Executing a Command

1. Open the `ox_lib` radial menu.
2. Select your configured slot to execute the assigned command immediately.