
import ressourceManager as ressources
import nimgl/[glfw, opengl]
import tables
import game

let
    SCREEN_WIDTH : int32 = 800
    SCREEN_HEIGHT : int32 = 600
    DEBUGGAME : bool = true

let gameObj: Game = Game(keys: initTable[int32, bool](), width: SCREEN_WIDTH, height: SCREEN_HEIGHT)

proc framebufferProc(window: GLFWWindow, width: int32, height: int32): void {.cdecl.} =
    glViewport(0, 0, width, height);

proc keyProc(window: GLFWWindow, key: int32, scancode: int32,
             action: int32, mods: int32): void {.cdecl.} =
    if key == GLFWKey.ESCAPE and action == GLFWPress:
        window.setWindowShouldClose(true)

    if (key >= 0 and key < 1024):
        if action == GLFW_PRESS:
            gameObj.keys[key] = true
        elif action == GLFW_RELEASE:
            gameObj.keys[key] = false

proc glDebugOutput (
    source: GLenum,
    typ: GLenum,
    id: GLuint,
    severity: GLenum,
    length: GLsizei,
    message: ptr GLchar,
    userParam: pointer) {.stdcall.} =
    echo message

proc main() =
    assert glfwInit()

    glfwWindowHint(GLFWContextVersionMajor, 3)
    glfwWindowHint(GLFWContextVersionMinor, 3)
    glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE)
    glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
    glfwWindowHint(GLFWResizable, GLFW_FALSE)
    glfwWindowHint(GLFWOpenglDebugContext, 1)
    let window: GLFWWindow = glfwCreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Breakout", nil, nil);
    if window == nil:
        quit(-1)
    discard window.setKeyCallback(keyProc)
    discard window.setFramebufferSizeCallback(framebufferProc)
    window.makeContextCurrent()
    
    assert glInit()

    glViewport(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

    glEnable(GL_DEBUG_OUTPUT)
    glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS);
    glDebugMessageCallback(glDebugOutput, nil)
    glDebugMessageControl(GL_DONT_CARE, GL_DONT_CARE, GL_DONT_CARE, GLsizei(0), nil, GLboolean(DEBUGGAME))

    gameObj.state = GAME_ACTIVE
    var
        deltaTime :float = 0.0f
        lastFrame :float = 0.0f

    assert glInit()
    gameObj.init()
    while not window.windowShouldClose:
        var currentFrame = glfwGetTime()
        deltaTime = currentFrame - lastFrame
        lastFrame = currentFrame
        glfwPollEvents()

        gameObj.processInput(deltaTime)
        gameObj.update(deltaTime)

        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT)
        gameObj.render()
        window.swapBuffers()


    window.destroyWindow()
    ressources.clear()
    glfwTerminate()


when isMainModule:
  main()
