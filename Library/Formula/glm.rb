class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "http://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.7.4/glm-0.9.7.4.zip"
  sha256 "d48a0d732776b0fbfd17f01c830a08b50f07a3226f0cab95fcca5591982a43f2"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29ff8490d5ea5ee326e7abfe1f293ad1b1eed335e7ae2a1f8bb8ae789c6ac704" => :el_capitan
    sha256 "36bc7186db700587e50a7a3a43455c4e9e6d66a6081d53353265b8fb09b0e8a3" => :yosemite
    sha256 "81b40ac922519c615c57703a94930ec577353d9327303e314fc6537b9615ded2" => :mavericks
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
