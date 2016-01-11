class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "http://www.geuz.org/gl2ps/"
  url "http://geuz.org/gl2ps/src/gl2ps-1.3.9.tgz"
  sha256 "8a680bff120df8bcd78afac276cdc38041fed617f2721bade01213362bcc3640"

  bottle do
    cellar :any
    sha256 "660715c44772d7fb7463216af03797a9f377390550857fafb60ff07e8307d54c" => :el_capitan
    sha256 "2641d23b28b8800c346e6c5b5579b56cbbfb5922086d9c68b3f51a243054c45f" => :yosemite
    sha256 "601ef91d17ee6390113b98ce744493eb71ab0d17026994dfa64f6a83783b6d79" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <GLUT/glut.h>
      #include <gl2ps.h>

      int main(int argc, char *argv[])
      {
        glutInit(&argc, argv);
        glutInitDisplayMode(GLUT_DEPTH);
        glutInitWindowSize(400, 400);
        glutInitWindowPosition(100, 100);
        glutCreateWindow(argv[0]);
        GLint viewport[4];
        glGetIntegerv(GL_VIEWPORT, viewport);
        FILE *fp = fopen("test.eps", "wb");
        GLint buffsize = 0, state = GL2PS_OVERFLOW;
        while( state == GL2PS_OVERFLOW ){
          buffsize += 1024*1024;
          gl2psBeginPage ( "Test", "Homebrew", viewport,
                           GL2PS_EPS, GL2PS_BSP_SORT, GL2PS_SILENT |
                           GL2PS_SIMPLE_LINE_OFFSET | GL2PS_NO_BLENDING |
                           GL2PS_OCCLUSION_CULL | GL2PS_BEST_ROOT,
                           GL_RGBA, 0, NULL, 0, 0, 0, buffsize,
                           fp, "test.eps" );
          gl2psText("Homebrew Test", "Courier", 12);
          state = gl2psEndPage();
        }
        fclose(fp);
        return 0;
      }
    EOS
    system ENV.cc, "-lgl2ps", "-framework", "OpenGL", "-framework", "GLUT", "-framework", "Cocoa", "test.c", "-o", "test"
    system "./test"
    assert File.exist?("test.eps") && File.size("test.eps") > 0
  end
end
