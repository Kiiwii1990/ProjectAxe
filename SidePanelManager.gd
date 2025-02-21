extends Control

# Declare variables for buttons and panels
var inventory_button : Button
var inventory_panel : Control  # Inventory panel
var equipment_button : Button  # Equipment button
var equipment_panel : Control  # Equipment panel
var default_inventory_image : Texture
var active_inventory_image : Texture
var default_equipment_image : Texture
var active_equipment_image : Texture

# This function is called when the scene is ready
func _ready():
	# Initialize buttons 
	inventory_button = $InventoryButton  # Ensure this matches the actual node name
	equipment_button = $EquipmentButton  # Ensure this matches the actual node name
	
	# Initialize panels 
	inventory_panel = $InventoryPanel  # Ensure this matches the actual node name
	equipment_panel = $EquipmentPanel  # Ensure this matches the actual node name
	
	# Initialize button images
	default_inventory_image = preload("res://UI/Side Menu/bagbutton.png")
	active_inventory_image = preload("res://UI/Side Menu/bagbuttonactive.png")
	default_equipment_image = preload("res://UI/Side Menu/equipmentbutton.png")
	active_equipment_image = preload("res://UI/Side Menu/equipmentbuttonactive.png")
	
	# Connect button clicks to functions
	inventory_button.pressed.connect(self._on_inventory_pressed)
	equipment_button.pressed.connect(self._on_equipment_pressed)  # Connect to equipment button

	# Initially hide all panels
	_hide_all_panels()

# Hide all panels
func _hide_all_panels():
	inventory_panel.hide()  # Hide the inventory panel
	equipment_panel.hide()  # Hide the equipment panel

# Open or close the inventory panel when the inventory button is pressed
func _on_inventory_pressed():
	if inventory_panel.visible:
		inventory_panel.hide()  # Close if it's already visible
		inventory_button.icon = default_inventory_image # Revert to default image
	else:
		_hide_all_panels()  # Hide other panels
		inventory_panel.show()  # Show the inventory panel
		inventory_button.icon = active_inventory_image  # Set active image
		
# Open or close the equipment panel when the equipment button is pressed
func _on_equipment_pressed():
	if equipment_panel.visible:
		equipment_panel.hide()  # Close if it's already visible
		equipment_button.icon = default_equipment_image  # Revert to default image
	else:
		_hide_all_panels()  # Hide other panels
		equipment_panel.show()  # Show the equipment panel
		equipment_button.icon = active_equipment_image  # Set active image
