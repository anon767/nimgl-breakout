import tables
import ressourceManager
import glm
import shader
import spriteRenderer

type
  GameState* = enum
    GAME_ACTIVE, GAME_MENU, GAME_WIN

type Game* = ref object
    keys*: Table[int32, bool]
    width*: int32
    height*: int32
    state*: GameState
    renderer : SpriteRenderer


proc update*(self: Game, dt: float) = discard
proc processInput*(self: Game, dt: float) = discard
proc render*(self: Game) = 
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
        # load textures
        discard loadTexture("assets/awesomeface.png", true, "face");