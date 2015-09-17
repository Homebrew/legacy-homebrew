class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "http://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.7.1/glm-0.9.7.1.zip"
  sha256 "aa1a504e991bbe33a32f394de8d39d43cc800cbb3d99c2fa75b4a473eba606db"

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
