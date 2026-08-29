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
	"[shake rate=20 level=10]H-h-help...[/shake] Please, can I have the key? Just for a second.",
	"I lost my ticket somewhere in the corridor... please, don't leave me out in the dark!",
	"Is somebody there? I can hear you breathing. Please, open up before it's too late!",
    "The lights out here are flickering... [color=yellow]something is moving[/color] down the carriage. Let me in!"
]

const HAPPINESS = [
	"Thank you so much! I'll be [rainbow freq=1.0 sat=0.8 val=0.8]so quiet, you won't even know I'm here[/rainbow], I promise!",
	"Oh, bless you! You won't hear a peep out of me, I swear.",
	"Thank you for letting me in! I'll stay completely out of your way, I promise.",
	"No way! Thank you so much! We're actually going to be okay!",
	"You are an absolute lifesaver! I was so terrified standing out there alone.",
	"Thank you, thank you, thank you! I'll sit right in the corner and not move an inch.",
    "I knew you were a good person! Let's lock this door tight together, okay?"
]

const ANGER = [
	"[shake rate=30 level=15][color=red]Why didn't you let me in?![/color][/shake] What is actually wrong with you?!",
	"Are you kidding me?! You're just going to lock me out?! [color=orange]You are going to regret this![/color]",
	"Open this door right now! [wave amp=30 freq=8]Why are you doing this to me?![/wave]",
	"Fine! Leave me out here! [color=darkred]You'll pay for this, I swear you will![/color]",
	"Coward! You're just hiding behind a locked door like a rat!",
	"Open the door! [shake rate=25 level=12]You think you're safe in there?[/shake] You're trapped with me!",
    "I remember your face! When I get back in, [color=red]you're finished[/color]!"
]

const KILLER_GREETINGS = [
	"[shake rate=25 level=20][color=darkred]I found you...[/color][/shake] Open up, there's nowhere left to run.",
	"It's so cold outside, but [color=red][pulse freq=4]my knife is nice and warm.[/pulse][/color] Let me in...",
	"[wave amp=25 freq=10]Tick-tock, little passenger.[/wave] Open the door before I take it down myself.",
	"You can't hide in that little compartment forever. [color=darkred]Let me in for a chat.[/color]",
	"Oh, look at you, peeking through the glass... [shake rate=35 level=15]I can see your eyes.[/shake]",
	"Open the door nicely, and maybe [color=purple]it will be quick[/color].",
    "Did you really think a wooden door would keep [color=red]me[/color] out?"
]

func greet():
	await get_tree().create_timer(delay).timeout
	if GameEvents.has_bad_npc:
		text = KILLER_GREETINGS.pick_random()
	else:
		text = GREETINGS.pick_random()
	animate()

func happy():
	var happiness = HAPPINESS.pick_random()
	text = happiness
	animate()

func angry():
	var anger = ANGER.pick_random()
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
