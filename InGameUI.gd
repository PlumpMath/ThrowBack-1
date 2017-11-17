extends CanvasLayer

const scoreLimit = 1
var countdownText
var newGameCount
var p1Score = 0
var p2Score = 0
var gameOver = false
var p1ScoreText
var p2ScoreText
var postGame
var midMatch
var pause
var canPause = false
var midMatchTimer
var preMatchTimer

func _ready():
	p1ScoreText = get_node("MidMatch/p1Score")
	p2ScoreText = get_node("MidMatch/p2Score")
	countdownText = get_node("MidMatch/timeDisplay")
	newGameCount = get_node("PreMatch/newGameCount")
	midMatch = get_node("MidMatch")
	postGame = get_node("PostGame")
	pause = get_node("Pause")
	midMatchTimer = get_node("MidMatch/Timer")
	preMatchTimer = get_node("PreMatch/Timer")
	updateScoreDisplay()
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_cancel") and !pause.is_visible() and canPause:
		pauseGame()
	if preMatchTimer.get_time_left() != 0:
		preMatch()
	elif midMatchTimer.get_time_left() !=0 or !gameOver:
		activeMatch()

func pauseGame():
	pause.show()
	get_tree().set_pause(true)

func preMatch():
	if preMatchTimer.get_time_left() > 1:
		newGameCount.set_text(str(floor(preMatchTimer.get_time_left())))
	else:
		newGameCount.set_text("GO!")
		newGameCount.set_self_opacity(preMatchTimer.get_time_left())


func activeMatch():
	if midMatchTimer.get_time_left() > 0:
		var formatTime = "%02d" % ceil(midMatchTimer.get_time_left())
		countdownText.set_text(formatTime)
	else:
		if p1Score == p2Score:
			countdownText.set_text("OT")
		else:
			gameOver = true
			endGame()

func p1Scores(amount):
	p1Score += amount
	return updateScoreDisplay()


func p2Scores(amount):
	p2Score += amount
	return updateScoreDisplay()
	
func updateScoreDisplay():
	var formatScore = "%02d" % p1Score
	p1ScoreText.set_text(formatScore)
	var formatScore = "%02d" % p2Score
	p2ScoreText.set_text(formatScore)
	if p1Score >= scoreLimit:
		endGame()
		return "p1"
	elif p2Score >= scoreLimit:
		endGame()
		return "p2"
	return ""
	
func endGame():
	canPause = false
	if p1Score > p2Score:
		postGame.setup(str(p1Score), str(p2Score), "WIN", "LOSE")
	else:
		postGame.setup(str(p1Score), str(p2Score), "LOSE", "WIN")
	postGame.show()
	midMatch.hide()

func newRound():
	preMatchTimer.start()
	newGameCount.set_self_opacity(1)

func _on_PreMatchTimer_timeout():
	newGameCount.set_self_opacity(preMatchTimer.get_time_left())
	midMatchTimer.start()
	get_tree().set_pause(false)
	canPause = true
