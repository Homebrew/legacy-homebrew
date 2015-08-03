class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "http://www.antisphere.com/Wiki/tools:anttweakbar"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  bottle do
    cellar :any
    sha1 "103b4c69883ace7c1d24a8ea9405669f491a00bc" => :yosemite
    sha1 "52b1d49b36d290e5f90897b3fb291c52c936007b" => :mavericks
    sha1 "370619e705719ed57ba0b31447c1f33a3b014c77" => :mountain_lion
  end

  # See
  # http://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch :DATA

  def install
    system "make", "-C", "src", "-f", "Makefile.osx"
    lib.install "lib/libAntTweakBar.dylib", "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end
end

__END__
diff --git a/src/LoadOGLCore.h b/src/LoadOGLCore.h
index 8aaab1e..b606d2b 100644
--- a/src/LoadOGLCore.h
+++ b/src/LoadOGLCore.h
@@ -146,7 +146,13 @@ ANT_GL_CORE_DECL(void, glGetCompressedTexImage, (GLenum target, GLint level, GLv
 // GL 1.4
 ANT_GL_CORE_DECL(void, glBlendFuncSeparate, (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha))
 ANT_GL_CORE_DECL(void, glMultiDrawArrays, (GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount))
+#if defined(ANT_OSX) && (MAC_OS_X_VERSION_MAX_ALLOWED >= 1080)
+// Mac OSX 10.8 SDK from March 2013 redefines this OpenGL call: glMultiDrawElements
+// if it doesn't compile, please update XCode.
+ANT_GL_CORE_DECL(void, glMultiDrawElements, (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* const*indices, GLsizei primcount))
+#else
 ANT_GL_CORE_DECL(void, glMultiDrawElements, (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount))
+#endif
 ANT_GL_CORE_DECL(void, glPointParameterf, (GLenum pname, GLfloat param))
 ANT_GL_CORE_DECL(void, glPointParameterfv, (GLenum pname, const GLfloat *params))
 ANT_GL_CORE_DECL(void, glPointParameteri, (GLenum pname, GLint param))
@@ -211,7 +217,13 @@ ANT_GL_CORE_DECL(void, glGetVertexAttribPointerv, (GLuint index, GLenum pname, G
 ANT_GL_CORE_DECL(GLboolean, glIsProgram, (GLuint program))
 ANT_GL_CORE_DECL(GLboolean, glIsShader, (GLuint shader))
 ANT_GL_CORE_DECL(void, glLinkProgram, (GLuint program))
+#if defined(ANT_OSX) && (MAC_OS_X_VERSION_MAX_ALLOWED >= 1080)
+// Mac OSX 10.8 SDK from March 2013 redefines this OpenGL call: glShaderSource
+// if it doesn't compile, please update XCode.
+ANT_GL_CORE_DECL(void, glShaderSource, (GLuint shader, GLsizei count, const GLchar* const*string, const GLint *length))
+#else
 ANT_GL_CORE_DECL(void, glShaderSource, (GLuint shader, GLsizei count, const GLchar* *string, const GLint *length))
+#endif
 ANT_GL_CORE_DECL(void, glUseProgram, (GLuint program))
 ANT_GL_CORE_DECL(void, glUniform1f, (GLint location, GLfloat v0))
 ANT_GL_CORE_DECL(void, glUniform2f, (GLint location, GLfloat v0, GLfloat v1))
diff --git a/src/LoadOGLCore.cpp b/src/LoadOGLCore.cpp
index 2daa573..b8b9151 100644
--- a/src/LoadOGLCore.cpp
+++ b/src/LoadOGLCore.cpp
@@ -484,7 +484,7 @@ namespace GLCore { PFNGLGetProcAddress _glGetProcAddress = NULL; }
         void *proc=NULL;
         if (gl_dyld == NULL)
         {
-            gl_dyld = dlopen("OpenGL",RTLD_LAZY);
+            gl_dyld = dlopen("/System/Library/Frameworks/OpenGL.framework/OpenGL",RTLD_LAZY);
         }
         if (gl_dyld)
         {
