class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "http://glm.g-truc.net/"
  url "https://mirrors.kernel.org/debian/pool/main/g/glm/glm_0.9.6.3.orig.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/glm/glm_0.9.6.3.orig.tar.xz"
  sha256 "f9ab688bd6af1e0c454d887e1f5506518f2530d195ce057d96be1a769d42dfbb"

  head "https://github.com/g-truc/glm.git"

  option "with-doxygen", "Build documentation"
  depends_on "doxygen" => [:build, :optional]

  def install
    include.install "glm"

    if build.with? "doxygen"
      cd "doc" do
        system "doxygen", "man.doxy"
        man.install "html"
      end
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glm/vec2.hpp>// glm::vec2
      int main()
      {
        std::size_t const VertexCount = 4;
        std::size_t const PositionSizeF32 = VertexCount * sizeof(glm::vec2);
        glm::vec2 const PositionDataF32[VertexCount] =
        {
          glm::vec2(-1.0f,-1.0f),
          glm::vec2( 1.0f,-1.0f),
          glm::vec2( 1.0f, 1.0f),
          glm::vec2(-1.0f, 1.0f)
        };
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
