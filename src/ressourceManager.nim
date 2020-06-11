import nimgl/opengl
import stb_image/read as stbi
import tables
import shader
import texture

var textures = initTable[string, Texture]()
var shaders = initTable[string, Shader]()


proc clear*() = 
    for key, val in shaders:
        glDeleteProgram(val.ID)
        
    for key, val in textures:
        glDeleteTextures(GLsizei(1), val.ID.addr)


proc loadShaderFromFile*(vShaderFile: string, fShaderFile: string, gShaderFile: string) : Shader =
    var vertexCode, fragmentCode, geometryCode : string = ""

    vertexCode = readFile(vShaderFile)
    fragmentCode = readFile(fShaderFile)

    if gShaderFile != "":
        geometryCode = readFile(gShaderFile)
    var shader = new Shader
    shader.compile(vertexCode, fragmentCode, geometryCode);
    shader

proc loadShader*(vShaderFile: string, fShaderFile: string, gShaderFile: string, name: string) : Shader =
    shaders[name] = loadShaderFromFile(vShaderFile, fShaderFile, gShaderFile);
    shaders[name]

proc getShader*(name: string) : Shader = shaders[name]


proc loadTextureFromFile* (file: string, alpha: bool) : Texture =
    # Create texture object
    var texture: Texture = makeTexture()
    if alpha:
        texture.internalFormat = GL_RGBA
        texture.imageFormat = GL_RGBA
    # Load image
    var width, height, nrChannels: int
    var data = stbi.load(file, width, height, nrChannels, stbi.Default)
    # Now generate texture
    texture.generate(uint32(width), uint32(height), data[0].addr)

    texture

proc loadTexture*(file: string, alpha: bool, name: string) : Texture =
    textures[name] = loadTextureFromFile(file, alpha)
    textures[name]

proc getTexture*(name: string) : Texture = textures[name]