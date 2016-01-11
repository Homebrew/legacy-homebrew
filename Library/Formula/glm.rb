class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "http://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.7.1/glm-0.9.7.1.zip"
  sha256 "aa1a504e991bbe33a32f394de8d39d43cc800cbb3d99c2fa75b4a473eba606db"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "202a4610ad4af2c69ec14e44ab2c0fd705e244c3dcaa158543c9a2424b2d4ea2" => :el_capitan
    sha256 "ea8662efa99bb907b691998db85c33aaf15581d4ae6149a8f77edc8f734e5450" => :yosemite
    sha256 "fa835fb96b3cf595f071894864c8c6c01cb1a4e2d7739e517bce6a3ada4b65bd" => :mavericks
  end

  option "with-doxygen", "Build documentation"
  depends_on "doxygen" => [:build, :optional]
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

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
