import funkin.backend.system.Flags;

var charShader = new FunkinShader('
#pragma header
void main() {
    vec4 bleh = textureCam(bitmap, getCamPos(openfl_TextureCoordv));
    float dude = dot(bleh.rgb / vec3(bleh.a), vec3(0.20, 0.72, 0.07));
    bleh = applyFlixelEffects(vec4(pow(1.0 - dude, 32.0)) * bleh.a);
    gl_FragColor = bleh;
}
');

var dad = new Character(0, 0, Flags.DEFAULT_OPPONENT);
var gf = new Character(0, 0, Flags.DEFAULT_GIRLFRIEND);
var boyfriend = new Character(0, 0, Flags.DEFAULT_CHARACTER, true, true);
var visibleChars = true;

function postCreate() {
	insert(members.indexOf(character), gf);
	insert(members.indexOf(character), dad);
	insert(members.indexOf(character), boyfriend);
}
var __trackedStage = null;
function postUpdate(elapsed) {
	if (__trackedStage != currentStage) {
		onStageChange(__trackedStage = currentStage);
	}
}

function onStageChange(s) {
	remove(boyfriend, true); remove(dad, true); remove(gf, true);
	if (currentStage == null) return;
	stage.characterPoses['dad'].revertCharacter(dad);
	stage.characterPoses['boyfriend'].revertCharacter(boyfriend);
	stage.characterPoses['girlfriend'].revertCharacter(gf);
	stage.characterPoses['dad'].prepareCharacter(dad, 0);
	stage.characterPoses['boyfriend'].prepareCharacter(boyfriend, 0);
	stage.characterPoses['girlfriend'].prepareCharacter(gf, 0);

	insert(Math.min(members.indexOf(character), members.indexOf(stage.characterPoses['girlfriend'])), gf);
	insert(Math.min(members.indexOf(character), members.indexOf(stage.characterPoses['dad'])), dad);
	insert(Math.min(members.indexOf(character), members.indexOf(stage.characterPoses['boyfriend'])), boyfriend);

	for (i in [dad, boyfriend, gf]) {
		i.blend = 0;
		i.cameras = [charCamera];
		i.shader = charShader;
		i.color = FlxColor.interpolate(i.iconColor ?? -1, -1, 0.4);
		i.alpha = 0.5;
		try {
			i.useRenderTexture = i.isAnimate;
		} catch(e:Dynamic) {
			trace(e);
		}
	}

	var item;
	item = {
		label: 'Show Stage Positions',
		icon: visibleChars ? 1 : 0,
		onSelect: (_) -> {
			visibleChars = !visibleChars;
			for (i in [dad, boyfriend, gf]) {
				i.visible = visibleChars;
			}
			item.icon = visibleChars ? 1 : 0;
		}
	};
	topMenuSpr.members[stageIndex].contextMenu.push(null);
	topMenuSpr.members[stageIndex].contextMenu.push(item);
}