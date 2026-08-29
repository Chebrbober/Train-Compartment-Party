extends Node2D

@export var type: Type = Type.Good
@export var body_bundles_array: Array[BodyBundle]
@onready var head: Sprite2D = %Head
@onready var right_arm: Sprite2D = %RightArm
@onready var left_arm: Sprite2D = %LeftArm
@onready var torso: Sprite2D = %Torso
@onready var right_leg: Sprite2D = %RightLeg
@onready var left_leg: Sprite2D = %LeftLeg
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var body_bundle: BodyBundle
var npc_type: Type = Type.values().pick_random()
enum Type {
	Good,
	Bad
}

func _ready() -> void:
	visible = false

func update() -> void:
	npc_type = Type.values().pick_random()
	body_bundle = body_bundles_array.pick_random()
	setup_body_bundle(body_bundle)

	GameEvents.has_bad_npc = (npc_type == Type.Bad)
	print("Npc is ", npc_type)

	if npc_type == Type.Good:
		animation_player.play("idle")
	else:
		animation_player.play("jagged_idle")

func setup_body_bundle(bundle: BodyBundle) -> void:
	head.texture = bundle.head
	right_arm.texture = bundle.right_arm
	left_arm.texture = bundle.left_arm
	torso.texture = bundle.torso
	right_leg.texture = bundle.right_leg
	left_leg.texture = bundle.left_leg
