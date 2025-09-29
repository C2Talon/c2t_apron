# c2t_apron

KoLmafia script written in ASH to handle the [Black and White Apron Meal Kit](https://wiki.kingdomofloathing.com/Black_and_White_Apron_Meal_Kit).

## Usage

Two options available for use:

### CLI

* `c2t_apron [mus|mys|mox]`

The command above will eat a kit with the given stat selected. Omitting the stat from the command will default to choosing whichever mafia thinks is the primary stat of your class.

### `import`ing

* `boolean c2t_apron(stat)`

`import`ing `c2t_apron.ash` into a script will make available the above function to eat a kit with the given stat selected. Omitting `stat` from the function call will default to choosing whichever mafia thinks is the primary stat of your class. The function will return `true` on success, and `false` with a message on any error.

### Extra Ingredients

Extra ingredients are selected from an allowlist must set beforehand, otherwise no extra ingredients will be used. The list is stored in the preference `c2t_apron_allowlist` as a comma-delimited list of item IDs of the ingredients. The fool-proof way to edit the allowlist is with the relay script provided, which can be accessed by finding the drop-down menu in the top-right corner of the menu pane that says `-run script-`, and then selecting `c2t apron`, as seen here:

![relay script location](https://github.com/C2Talon/c2t_apron/blob/master/relay_script_location.png "relay script location")

If the selection is not showing after installation, either the pane that contains the drop-down menu or the whole page needs to be refreshed for it to show up.

## Installation

To install, run the following on the gCLI:

`git checkout https://github.com/C2Talon/c2t_apron.git master`

