
�

Room.protoRoomPlayer.proto"H
KeyMoveData
posX (
posY (
angle (
roleId (	"?
KeyLogicData
skillId (
propId (
roleId (	"\
ReqMoveKeyData#
moveData (2.Room.KeyMoveData
userId (	"
MsgID
eMsgID��	"b
ReqLogicKeyData(
logicKeyData (2.Room.KeyLogicData
userId (	"
MsgID
eMsgID��	"M
ResMoveKeyDatas#
moveData (2.Room.KeyMoveData"
MsgID
eMsgIDƜ	"T
ResLogicKeyDatas)
logicKeyDatas (2.Room.KeyLogicData"
MsgID
eMsgIDǜ	"L
ReqUDPEnterRoom

roomNumber (
userId (	"
MsgID
eMsgID��	"O
RoomInfo
roomId (	
roomNum (
roomType (
gameType ("J
ReqCreateRoom
roomType (
gameType ("
MsgID
eMsgID��	"m
ReqEnterRoom

roomNumber (
roomType (
bQuick (
gameType ("
MsgID
eMsgID��	"G
ReqLeaveRoom 
roomInfo (2.Room.RoomInfo"
MsgID
eMsgID��	"�
ZJH_AddScore
compareState (
addScoreCount (
currentTimes (
currentCellScore (
currentTotalScore (
currentPlayTimes ("g
ZJH_CompareCard
comparePlayerId (	
compareResult (
cards (	
comparedCards	 (	"
ZJH_LookCard
cards (	"�
Action

actionType (
playerId (	(
zjh_addScore (2.Room.ZJH_AddScore.
zjh_comparecard (2.Room.ZJH_CompareCard(
zjh_lookcard	 (2.Room.ZJH_LookCard
zjh_followForever
 ("A
	ReqAction
actions (2.Room.Action"
MsgID
eMsgID��	"�
ResEnterRoom 
roomInfo (2.Room.RoomInfo
playerId (	*
playerBaseInfo (2.Player.PlayerInfo
locationIndex (
bReady	 (
gameType ("
MsgID
eMsgIDՔ	"7
ResLeaveRoom
playerId (	"
MsgID
eMsgID֔	"@
	ResAction
action (2.Room.Action"
MsgID
eMsgIDה	"J
ResWillExcuteAction
action (2.Room.Action"
MsgID
eMsgIDؔ	"�
ZJHDeskData
maxScore (
	cellScore (
currentTimes (
maxScoreLimit (
bankerPlayerId (	
currentPlayerId (	"8
FightDeskData'
zjh_DeskData (2.Room.ZJHDeskData"F
ZJHPlayerFightData
playerId (	
isReady (
cards (	"G
PlayerFightData4
zjhPlayerFightData (2.Room.ZJHPlayerFightData"�
ZJH_GameResult
gameTax (3

playerCard (2.Room.ZJH_GameResult.PlayerCard
winnerLocation (?

PlayerCard
playerId (	
cards (	
getScore ("U
ResFightResult,
zjh_gameResult (2.Room.ZJH_GameResult"
MsgID
eMsgIDٔ	"�
ResGameStartFightData.
playerFightData (2.Room.PlayerFightData*
fightDeskData (2.Room.FightDeskData

fightState ("
MsgID
eMsgIDڔ	B
game.messageBRoomMessage