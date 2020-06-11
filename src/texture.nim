import nimgl/opengl

type Texture* = ref object
    ID*: GLuint
    width*: uint
    height*: uint
    internalFormat*: GLenum
    imageFormat*: GLenum
    wrapS: GLenum
    wrapT: GLenum
    filterMin: GLenum
    filterMax: GLenum

proc makeTexture*() : Texture =
    var texture = Texture(width: 0, height: 0, internalFormat: GL_RGB, imageFormat: GL_RGB, wrapS: GL_REPEAT, wrapT: GL_REPEAT, filterMin: GL_LINEAR, filterMax: GL_LINEAR)
    glGenTextures(1, texture.ID.addr)
    texture

proc generate*(self: Texture, width: uint32, height: uint32, data: ptr) =
    self.width = width
    self.height = height
    # Create Texture
    glBindTexture(GL_TEXTURE_2D, self.ID);
    glTexImage2D(GL_TEXTURE_2D, GLint(0), GLint(self.internalFormat), GLsizei(width), GLsizei(height), GLint(0), self.imageFormat, GL_UNSIGNED_BYTE, data)
    # set Texture wrap and filter modes
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GLint(self.wrapS))
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GLint(self.wrapT))
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GLint(self.filterMin))
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GLint(self.filterMax))
    # unbind texture
    glBindTexture(GL_TEXTURE_2D, 0); 

proc bindt*(self: Texture) =
    glBindTexture(GL_TEXTURE_2D, self.ID);
