# Unlimited Cars
Allow as amny cars as you want in a plannet coaster 2 mod

### Cobra Tools setup
This repository is set up to work with the "flatten lua subfolders" setting in Cobra Tools. Please turn it on if it isn't. If you do not want to use this setting, simply add `database.` to the start of the luadatabase file, and move it directly under the Main folder.

### Packaging
In the OVL tool `ovl_tool_gui.py`, navigate in the top bar to `File > New`. Then select the Main folder within this folder. You will note any lua or file errors in the console. Then, navigate to `File > Save`, this will save the OVL, and you should see the toplevel directory contains three files:
- Main (folder)
- Main.ovl
- Manifest.xml

You should then, if running ACSEDebug, see the printout in the log: `INSERT_MODNAME_HERE called Init()!`. If you do not see this, something has gone wrong. Recheck all renames, and make sure your Manifest has a UUID.