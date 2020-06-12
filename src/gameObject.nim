import glm
import texture
import spriteRenderer
type GameObject* = ref object of RootObj
        position*: Vec2f
        size*: Vec2f
        velocity*: Vec2f
        color*: Vec3f
        rotation*: float
        isSolid*: bool
        isDestroyed*: bool
        sprite*: Texture

proc drawSprite*(self: GameObject, renderer: SpriteRenderer) =
        renderer.drawSprite(self.sprite, self.position, self.size, self.rotation, self.color)

proc createGameObject*(position: Vec2f, size: Vec2f, sprite: Texture, color: Vec3f, isSolid: bool) : GameObject =
    GameObject(position: position, size: size, velocity: vec2f(0f), color: color, rotation: 0f, isSolid: isSolid, isDestroyed: false, sprite: sprite)
