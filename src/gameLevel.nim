import spriteRenderer
import gameObject
import strutils
import ressourceManager
import glm

type GameLevel* = ref object
      bricks*: seq[GameObject]

let brickColors : array = [vec3(0f,0f,0f), vec3(0.8f, 0.8f, 0.7f), vec3(0.2f, 0.6f, 1.0f), vec3(0.0f, 0.7f, 0.0f), vec3(0.8f, 0.8f, 0.4f), vec3(1.0f, 0.5f, 0.0f)]


proc draw*(self: GameLevel, renderer: SpriteRenderer) = 
    for tile in self.bricks:
        if not tile.isDestroyed:
            tile.drawSprite(renderer)

proc isCompleted*(self: GameLevel): bool =
    for tile in self.bricks:
        if not (tile.isSolid or tile.isDestroyed):
            return false
    return true


proc init(self: GameLevel, tileData: seq[seq[uint]], levelWidth: int32, levelHeight: int32) = 
    var 
        height: int = tileData.len()
        width: int = tileData[0].len()
        unitHeight: float = levelHeight.float/height.float
        unitWidth: float = levelWidth.float/width.float
    for y in countup(0, height-1):
        for x in countup(0, width-1):
            let 
                pos = vec2f(unitWidth*x.float, unitHeight*y.float)
                size = vec2f(unitWidth, unitHeight)
            if tileData[y][x] == 1'u:
                self.bricks.add(createGameObject(pos, size, getTexture("block_solid"), brickColors[tileData[y][x]], true))
            elif tileData[y][x] > 1'u:
                self.bricks.add(createGameObject(pos, size, getTexture("block_solid"), brickColors[tileData[y][x]], false))

proc load*(self: GameLevel, file: string, levelWidth: int32, levelHeight: int32) = 
    self.bricks.setLen(0)
    var tileData: seq[seq[uint]]
    let levelContent = readFile(file)
    for line in levelContent.split("\n"):
        var row: seq[uint] = newSeq[uint]()
        for num in line.split(" "):
            if num.isDigit():
                row.add(parseUInt(num))
        tileData.add(row)
    if tileData.len > 0:
        self.init(tileData, levelWidth, levelHeight)


