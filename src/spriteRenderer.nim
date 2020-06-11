import shader
import texture
import nimgl/opengl
import glm
type SpriteRenderer* = ref object
    shader*: Shader
    quadVAO: GLuint

proc initRenderData*(self: SpriteRenderer) = 
    var VBO: GLuint
    var vert = @[
        0.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 1.0f, 0.0f
    ]
    glGenVertexArrays(1, self.quadVAO.addr)
    glGenBuffers(1, VBO.addr)
    glBindBuffer(GL_ARRAY_BUFFER, VBO)
    glBufferData(GL_ARRAY_BUFFER, cfloat.sizeof * vert.len, vert[0].addr, GL_STATIC_DRAW)
    glBindVertexArray(self.quadVAO)
    glEnableVertexAttribArray(0)
    glVertexAttribPointer(GLuint(0), GLint(4), EGL_FLOAT, false, cfloat.sizeof * 4, nil)
    glBindBuffer(GL_ARRAY_BUFFER, 0)
    glBindVertexArray(0)

proc drawSprite*(self: SpriteRenderer, texture: Texture, position: Vec2, size: Vec2, rotate: float, color: Vec3) = 
    discard self.shader.use()
    var model = mat4(1.0f)
    model = model
    .translate(vec3(position, 0.0f))
    .translate(vec3(0.5f * size.x, 0.5f * size.y, 0.0f))
    .rotate(radians(rotate), vec3(0.0f, 0.0f, 1.0f))
    .translate(vec3(-0.5f * size.x, -0.5f * size.y, 0.0f))
    .scale(vec3(size, 1.0f))

    self.shader.setMatrix4("model", model, false)
    self.shader.setVector3f("spriteColor", color, false)
    glActiveTexture(GL_TEXTURE0)
    texture.bindt()
    glBindVertexArray(self.quadVAO)
    glDrawArrays(GL_TRIANGLES, 0, 6)
    glBindVertexArray(0)
