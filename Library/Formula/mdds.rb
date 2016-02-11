class Mdds < Formula
  desc "multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "http://kohei.us/files/mdds/src/mdds-1.1.0.tar.bz2"
  sha256 "4253ab93fe8bb579321a50e247f1f800191ab99fe2d8c6c181741b8bd3fb161f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fac0ca8a8b5fd716123480278668ff6e91a2f9c8550e1566fa4d77d364dca7a3" => :el_capitan
    sha256 "b5f47377a54114b6145bd613fd827626506264c5febe8a6cf7a52619415e8505" => :yosemite
    sha256 "9b85733acd96f6cf98db27e6b19aeb03fa83f63d5522dd3684933a1a1bd95523" => :mavericks
  end

  depends_on "boost"
  needs :cxx11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include}/mdds-1.0"
    system "./test"
  end
end
