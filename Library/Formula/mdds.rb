class Mdds < Formula
  desc "multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "http://kohei.us/files/mdds/src/mdds-1.1.0.tar.bz2"
  sha256 "4253ab93fe8bb579321a50e247f1f800191ab99fe2d8c6c181741b8bd3fb161f"

  bottle do
    cellar :any_skip_relocation
    sha256 "47a1316524f2717d7dbac84c1c060dac8e2297ef61dd86e9350d202e30f19a74" => :el_capitan
    sha256 "e03dfcf7ba2f4d84226b8cb53745d7aa52d5413ce3f55e937b42975bc475bbee" => :yosemite
    sha256 "defd1f5bddfd8666b53e295e98f7d184005230adec3e6cd67ff964217eca36eb" => :mavericks
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
