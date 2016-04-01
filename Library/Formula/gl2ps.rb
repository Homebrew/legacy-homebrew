class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "http://www.geuz.org/gl2ps/"
  url "http://geuz.org/gl2ps/src/gl2ps-1.3.9.tgz"
  sha256 "8a680bff120df8bcd78afac276cdc38041fed617f2721bade01213362bcc3640"
  revision 1

  bottle do
    cellar :any
    sha256 "af82ad002b72c82f5b8a044cd00e1ad95f2ec44817587c1840e17b97c607bebc" => :el_capitan
    sha256 "482602fc793e919858a03aedfd1c40efd1763fea28fa71f02831ca1b906a3d9d" => :yosemite
    sha256 "89f18a491419c552d7b833290f9e7e25dfecece961ed2c0cd9c68a8352a1015a" => :mavericks
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
