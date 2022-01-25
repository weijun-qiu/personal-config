# Kill running xcape if there is one
pkill xcape

# Use existing keys to prevent emacs warnings
KEY1=Hyper_L
KEY2=Hyper_R

# Mapping Return to Control if pressed along with other keys
xmodmap -e "keycode 36 = ${KEY1}"
xmodmap -e "remove mod4 = ${KEY1}" # Hyper_L is originally in mod4
xmodmap -e "add control = ${KEY1}"
xmodmap -e "keycode any = Return"
xcape -e "${KEY1}=Return"

# Mapping Caps_Lock to Control
xmodmap -e "clear lock"
xmodmap -e "keycode 66 = ${KEY2}"
xmodmap -e "remove mod4 = ${KEY2}" # Hyper_R is originally in mod4
xmodmap -e "add control = ${KEY2}"
xmodmap -e "keycode any = Caps_Lock"
xmodmap -e "add lock = Caps_Lock"
xcape -e "${KEY2}=Caps_Lock"
