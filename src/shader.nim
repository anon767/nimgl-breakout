import nimgl/opengl
import glm

type Shader* = ref object
    ID*: GLuint

proc use*(self: Shader): Shader = 
    glUseProgram(self.ID)
    self

proc checkCompileErrors(obj: GLuint, otype: string) =
    var success: GLint
    var message = newSeq[char](1024)
    if otype != "PROGRAM":
        glGetShaderiv(obj, GL_COMPILE_STATUS, success.addr)
        glGetShaderInfoLog(obj, 1024, nil, message[0].addr);
    else:
        glGetProgramiv(obj, GL_LINK_STATUS, success.addr);
        glGetProgramInfoLog(obj, 1024, nil, message[0].addr);
    echo cast[string](message)


proc compile*(self: Shader, vertexSource: string, fragmentSource: string, geometrySource: string) =
    var vertexs: cstring = cstring(vertexSource)
    var fragments: cstring = cstring(fragmentSource)
    var geometrys: cstring = cstring(geometrySource)
    var sVertex, sFragment, gShader: GLuint
    # Vertex Shader
    sVertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(sVertex, GLsizei(1), vertexs.addr,  nil)
    glCompileShader(sVertex)
    checkCompileErrors(sVertex, "VERTEX");
    # Fragment Shader
    sFragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(sFragment, GLsizei(1), fragments.addr, nil)
    glCompileShader(sFragment)
    checkCompileErrors(sFragment, "FRAGMENT");
    # If geometry shader source code is given, also compile geometry shader
    if geometrySource != "":
        gShader = glCreateShader(GL_GEOMETRY_SHADER)
        glShaderSource(gShader, GLsizei(1), geometrys.addr, nil)
        glCompileShader(gShader)
        checkCompileErrors(gShader, "GEOMETRY")
    # Shader Program
    self.ID = glCreateProgram()
    glAttachShader(self.ID, sVertex)
    glAttachShader(self.ID, sFragment)
    if (geometrySource != ""):
        glAttachShader(self.ID, gShader)
    glLinkProgram(self.ID)
    checkCompileErrors(self.ID, "PROGRAM")
    # Delete the Shaders as they are linked to the Program
    glDeleteShader(sVertex);
    glDeleteShader(sFragment);
    if (geometrySource != ""):
        glDeleteShader(gShader);



proc setFloat* (self: Shader, name: string, value: float32, useShader: bool) =
    if useShader:
        discard self.use()
    glUniform1f(glGetUniformLocation(self.ID, name), value)

proc setInteger* (self: Shader, name: string, value: int32, useShader: bool) =
    if useShader:
        discard self.use()
    glUniform1i(glGetUniformLocation(self.ID, name), value)

proc setVector2f* (self: Shader, name: string, x: float32, y: float32, useShader: bool) =
    if useShader:
        discard self.use()
    glUniform2f(glGetUniformLocation(self.ID, name), x, y)

proc setVector3f* (self: Shader, name: string, vec: Vec3f, useShader: bool) =
    if useShader:
        discard self.use()
    glUniform3f(glGetUniformLocation(self.ID, name), vec.x, vec.y, vec.z)

proc setVector3f* (self: Shader, name: string, x: float32, y: float32, z: float32, useShader: bool) =
    if useShader:
        discard self.use()
    glUniform3f(glGetUniformLocation(self.ID, name), x, y, z)

proc setVector4f* (self: Shader, name: string, x: float32, y: float32, z: float32, m: float32, useShader: bool) =
    if useShader:
        discard self.use()
    glUniform4f(glGetUniformLocation(self.ID, name), x, y, z, m)

proc setMatrix4* (self: Shader, name: string, mat: var Mat4f, useShader: bool) =
    if useShader:
        discard self.use()
    glUniformMatrix4fv(glGetUniformLocation(self.ID, name), 1, false, mat.caddr);