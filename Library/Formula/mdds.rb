class Mdds < Formula
  desc "multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "http://kohei.us/files/mdds/src/mdds_1.0.0.tar.bz2"
  sha256 "ef8abc1236b54c7ca16ae1ee38abfb9cdbc5d1e6a2427c65b92b8c1003e3bf56"

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
