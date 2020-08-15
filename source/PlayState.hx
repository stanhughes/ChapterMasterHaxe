package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;
import flixel.util.FlxStringUtil;

class PlayState extends FlxState
{
	final chapters = 239;
	var chapterCount = 0;
	var chapterRead:FlxText;
	var percentageRead:FlxText;
	var percentageToRead:FlxText;
	var saveState:FlxSave;

	override public function create()
	{
		super.create();

		final spacing = 90;
		final rightMargin = 70;
		final titleSize = 64;
		final labelSize = 36;

		saveState = new FlxSave();
		saveState.bind('SaveState');

		if (saveState.data.chapterCount == null)
		{
			trace('creating initial chapter count');
			saveState.data.chapterCount = 0;
		}
		else
		{
			trace('loading saved data');
			chapterCount = saveState.data.chapterCount;
		}

		add(new flixel.text.FlxText(rightMargin, 1 * spacing, 0, 'Chapter Master', titleSize));

		chapterRead = new FlxText(rightMargin, 2 * spacing, 0, 'Chapters Read: ${chapterCount}', labelSize);
		add(chapterRead);

		percentageRead = new FlxText(rightMargin, 3 * spacing, 0, 'Percentage Read: ${(chapterCount / chapters) * 100} percent', labelSize);
		add(percentageRead);

		percentageToRead = new FlxText(rightMargin, 4 * spacing, 0, 'Percentage to Read: ${100 - ((chapterCount / chapters) * 100)} percent', labelSize);
		add(percentageToRead);

		var currentLocation = new FlxText(rightMargin, 5 * spacing, 0, 'Current Location: 1 Nephi 1:1', labelSize);
		add(currentLocation);

		var readChapter = new FlxButton(2 * rightMargin, 6 * spacing, 'Read Chapter', readChapterPushed);
		readChapter.height = 200;
		readChapter.width = 400;
		readChapter.getHitbox().height = 4 * spacing;
		readChapter.getHitbox().width = 6 * spacing;
		add(readChapter);
	}

	function readChapterPushed()
	{
		chapterCount += 1;
		saveTheState();
	}

	override public function update(elapsed:Float)
	{
		chapterRead.text = 'Chapters Read: ${chapterCount}';
		percentageRead.text = 'Percentage Read: ${FlxStringUtil.formatMoney((chapterCount / chapters) * 100)} percent';
		percentageToRead.text = 'Percentage to Read: ${FlxStringUtil.formatMoney(100 - ((chapterCount / chapters) * 100))} percent';

		// saveTheState();

		super.update(elapsed);
	}

	function saveTheState()
	{
		saveState.data.chapterCount = chapterCount;
		saveState.flush();
		trace('save state');
	}

	override public function kill()
	{
		saveTheState();

		super.kill();
	}
}
