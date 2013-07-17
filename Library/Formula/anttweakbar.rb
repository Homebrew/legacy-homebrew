require 'formula'

class Anttweakbar < Formula
  homepage 'http://www.antisphere.com/Wiki/tools:anttweakbar'
  url 'http://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip'
  version '1.16'
  sha1 '5743321df3b074f9a82b5ef3e6b54830a715b938'

  # https://sourceforge.net/p/anttweakbar/tickets/8/
  def patches
    DATA
  end
  
  def install
    cd 'src' do
      system 'make -f Makefile.osx'
    end
    lib.install 'lib/libAntTweakBar.dylib'
    include.install 'include/AntTweakBar.h'
  end
end


__END__
diff --git a/src/LoadOGLCore.h b/src/LoadOGLCore.h
index 8aaab1e..be29b14 100644
--- a/src/LoadOGLCore.h
+++ b/src/LoadOGLCore.h
@@ -146,7 +146,7 @@ ANT_GL_CORE_DECL(void, glGetCompressedTexImage, (GLenum target, GLint level, GLv
 // GL 1.4
 ANT_GL_CORE_DECL(void, glBlendFuncSeparate, (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha))
 ANT_GL_CORE_DECL(void, glMultiDrawArrays, (GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount))
-ANT_GL_CORE_DECL(void, glMultiDrawElements, (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount))
+ANT_GL_CORE_DECL(void, glMultiDrawElements, (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* const *indices, GLsizei primcount))
 ANT_GL_CORE_DECL(void, glPointParameterf, (GLenum pname, GLfloat param))
 ANT_GL_CORE_DECL(void, glPointParameterfv, (GLenum pname, const GLfloat *params))
 ANT_GL_CORE_DECL(void, glPointParameteri, (GLenum pname, GLint param))
@@ -211,7 +211,7 @@ ANT_GL_CORE_DECL(void, glGetVertexAttribPointerv, (GLuint index, GLenum pname, G
 ANT_GL_CORE_DECL(GLboolean, glIsProgram, (GLuint program))
 ANT_GL_CORE_DECL(GLboolean, glIsShader, (GLuint shader))
 ANT_GL_CORE_DECL(void, glLinkProgram, (GLuint program))
-ANT_GL_CORE_DECL(void, glShaderSource, (GLuint shader, GLsizei count, const GLchar* *string, const GLint *length))
+ANT_GL_CORE_DECL(void, glShaderSource, (GLuint shader, GLsizei count, const GLchar* const *string, const GLint *length))
 ANT_GL_CORE_DECL(void, glUseProgram, (GLuint program))
 ANT_GL_CORE_DECL(void, glUniform1f, (GLint location, GLfloat v0))
 ANT_GL_CORE_DECL(void, glUniform2f, (GLint location, GLfloat v0, GLfloat v1))
