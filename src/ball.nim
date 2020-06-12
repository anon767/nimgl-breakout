import gameObject
import glm
import texture

type Ball* = ref object of GameObject
    radius*: float
    isStuck*: bool

# Initial velocity of the Ball
let  INITIAL_BALL_VELOCITY = vec2f(100.0f, -350.0f)

proc createBall*(position: Vec2f, radius: float, sprite: Texture): Ball =
    Ball(position: position, velocity: INITIAL_BALL_VELOCITY, size: vec2f(radius * 2.0f, radius * 2.0f), sprite: sprite, color: vec3f(1.0f, 1.0f, 1.0f), isSolid: true, isStuck: true, radius: radius)

proc move*(self: Ball, dt: float, windowWidth: uint) : Vec2f =
    if not self.isStuck:
        self.position += self.velocity * dt
        if self.position.x <= 0.0f:
            self.velocity.x = -self.velocity.x
            self.position.x = 0.0f
        elif self.position.x + self.size.x >= float(windowWidth):
            self.velocity.x = -self.velocity.x
            self.position.x = float(windowWidth) - self.size.x
        
        if self.position.y <= 0.0f:
            self.velocity.y = -self.velocity.y
            self.position.y = 0
    self.position

proc reset*(self: Ball, position: Vec2, velocity: Vec2) =
    self.position = position
    self.velocity = velocity
    self.isStuck = true
