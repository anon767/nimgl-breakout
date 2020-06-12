import tables
import ressourceManager
import glm
import shader
import spriteRenderer
import gameLevel
import gameObject
import nimgl/glfw
import ball
type
  GameState* = enum
    GAME_ACTIVE, GAME_MENU, GAME_WIN

type Game* = ref object
    keys*: Table[int32, bool]
    width*: int32
    height*: int32
    state*: GameState
    renderer : SpriteRenderer
    levels: seq[GameLevel]
    currentLevel: int
    player: GameObject
    ball: Ball

# Initial size of the player paddle
let PLAYER_SIZE = vec2f(100.0f, 20.0f)
# Initial velocity of the player paddle
let PLAYER_VELOCITY = 500.0f
# Radius of Ball Object
let BALL_RADIUS = 12.5f

proc update*(self: Game, dt: float) = 
    discard self.ball.move(dt, uint(self.width))

proc processInput*(self: Game, dt: float) = 
        case self.state
            of GAME_ACTIVE:
                let velocity: float = PLAYER_VELOCITY * dt
                if GLFWKey.A in self.keys and self.keys[GLFWKey.A]:
                     if self.player.position.x >= 0.0f:
                        self.player.position.x -= velocity;
                        if self.ball.isStuck:
                            self.ball.position.x -= velocity
                if GLFWKey.D in self.keys and self.keys[GLFWKey.D]:
                     if self.player.position.x <= self.width.float - self.player.size.x:
                        self.player.position.x += velocity
                        if self.ball.isStuck:
                            self.ball.position.x += velocity
                if GLFWKey.Space in self.keys and self.keys[GLFWKey.Space]:
                    self.ball.isStuck = false
            else:
                discard
                

proc render*(self: Game) = 
    case self.state
        of GAME_ACTIVE:
            # Draw background
            self.renderer.drawSprite(getTexture("background"), 
                vec2(0.0f, 0.0f), vec2(float32(self.width), float32(self.height)), 0.0f, vec3(1.0f,1.0f,1.0f))
            # Draw level
            self.levels[self.currentLevel].draw(self.renderer)
            self.player.drawSprite(self.renderer)  
            self.ball.drawSprite(self.renderer)
        else:
            self.renderer.drawSprite(getTexture("face"), 
            vec2(200.0f, 200.0f), vec2(300.0f, 400.0f), 45.0f, vec3(0.0f, 1.0f, 0.0f))
        
proc init*(self: Game) = 
        discard loadShader("assets/vertex.s", "assets/fragment.s", "", "sprite")
        var projection = ortho(0f, float32(self.width), float32(self.height), 0f, -1.0f, 1.0f)
        getShader("sprite")
        .use()
        .setInteger("image", 0, false)
        getShader("sprite")
        .setMatrix4("projection", projection, false)
        self.renderer = SpriteRenderer(shader: getShader("sprite"))
        self.renderer.initRenderData()
        # Load textures
        discard loadTexture("assets/awesomeface.png", true, "face")
        discard loadTexture("assets/background.jpg", false, "background")
        discard loadTexture("assets/block.png", false, "block")
        discard loadTexture("assets/block_solid.png", false, "block_solid")
        discard loadTexture("assets/paddle.png", true, "paddle")
        # Load levels
        let one, two, three, four: GameLevel = GameLevel()
        one.load("assets/level1.txt", self.width, self.height div 2)
        two.load("assets/level2.txt", self.width, self.height div 2)
        three.load("assets/level3.txt", self.width, self.height div 2)
        four.load("assets/level4.txt", self.width, self.height div 2)
        self.levels.add(one)
        self.levels.add(two)
        self.levels.add(three)
        self.levels.add(four)
        self.currentLevel = 0
        let playerPos = vec2f(
            self.width.float / 2.0f - PLAYER_SIZE.x / 2.0f, 
            self.height.float - PLAYER_SIZE.y
        )
        self.player = createGameObject(playerPos, PLAYER_SIZE, getTexture("paddle"), vec3(1.0f,1.0f,1.0f), true)
        let ballPos = playerPos + vec2(PLAYER_SIZE.x / 2.0f - BALL_RADIUS, -BALL_RADIUS * 2.0f)
        self.ball = createBall(ballPos, BALL_RADIUS, getTexture("face"))