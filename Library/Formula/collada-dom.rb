require 'formula'

class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage 'https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM'
  url 'https://github.com/rdiankov/collada-dom/archive/v2.4.3.tar.gz'
  sha256 'ba4d273ff68b882b89a536dc9e6d057b37c651cb476a6cfe85d119b7e60b6cce'

  depends_on 'cmake' => :build
  depends_on 'pcre'
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    (testpath/'test_simple.cpp').write <<-EOS.undent
      #include "dae.h"

      int main() {
        DAE dae;
        dae.add("simple.dae");
        dae.writeAll();
        return 0;
      }
    EOS

    system ENV.cc, "test_simple.cpp", "-I#{include}/collada-dom2.4",
                   "-lstdc++", "-lcollada-dom2.4-dp",
                   "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./a.out"

    expected = <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <COLLADA xmlns="http://www.collada.org/2008/03/COLLADASchema" version="1.5.0"/>
    EOS
    assert_equal expected, File.open("simple.dae", "rb").read
  end
end
