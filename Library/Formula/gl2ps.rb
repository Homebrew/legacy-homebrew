class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "http://www.geuz.org/gl2ps/"
  url "http://geuz.org/gl2ps/src/gl2ps-1.3.8.tgz"
  sha256 "2fe58dd95df06688a8c188e70b1803093ebf0797954901f4a36a403dbc301ee5"
  revision 1

  bottle do
    cellar :any
    sha1 "ed85fb272142121ab9e28a79266cfcf6dd6e60ce" => :yosemite
    sha1 "f80c1fbd51b505902fb8a00f7fd97133cc9be4b0" => :mavericks
    sha1 "5650d4b48f26d1a5bf66b86db927cc672eef95d3" => :mountain_lion
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
