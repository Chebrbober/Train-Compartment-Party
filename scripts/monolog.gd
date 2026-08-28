extends RichTextLabel

@export var delay: float = 1.0
@export var tween_duration: float = 2.0
var tween: Tween

func _ready() -> void:
	GameEvents.peephole_opened.connect(greet)
	GameEvents.npc_invited.connect(reset)
	GameEvents.npc_raged.connect(reset)

const GREETINGS = [
    "Is anyone there? Let me in, it's [color=lightblue]freezing[/color] out here... my hands are going numb!",
    "Hello? Can you hear me? [wave amp=20 freq=5]Please, just open the door...[/wave] I don't have much time.",
    "Hey! I need to get inside before [color=red]they[/color] find me out here!",
    "[shake rate=20 level=10]H-h-help...[/shake] Please, can I have the key? Just for a second."
]

const HAPPINESS = [
    "Thank you so much! I'll be [rainbow freq=1.0 sat=0.8 val=0.8]so quiet, you won't even know I'm here[/rainbow], I promise!",
    "Oh, bless you! You won't hear a peep out of me, I swear.",
    "Thank you for letting me in! I'll stay completely out of your way, I promise.",
    "No way! Thank you so much! We're actually going to be okay!"
]

const ANGER = [
    "[shake rate=30 level=15][color=red]Why didn't you let me in?![/color][/shake] What is actually wrong with you?!",
    "Are you kidding me?! You're just going to lock me out?! [color=orange]You are going to regret this![/color]",
    "Open this door right now! [wave amp=30 freq=8]Why are you doing this to me?![/wave]",
    "Fine! Leave me out here! [color=darkred]You'll pay for this, I swear you will![/color]"
]

func greet():
	await get_tree().create_timer(delay).timeout
	var greeting = GREETINGS[randi_range(0, GREETINGS.size() -1)]
	text = greeting
	animate()

func happy():
	var happiness = HAPPINESS[randi_range(0, GREETINGS.size() -1)]
	text = happiness
	animate()

func angry():
	var anger = ANGER[randi_range(0, GREETINGS.size() -1)]
	text = anger
	animate()

func animate():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, tween_duration).from(0.0)

func reset():
	text = ""
	visible_ratio = 0.0
