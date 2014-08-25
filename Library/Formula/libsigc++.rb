require 'formula'

class Libsigcxx < Formula
  homepage 'http://libsigc.sourceforge.net'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.2/libsigc++-2.2.11.tar.xz'
  sha256 '9834045f74f56752c2c6b3cdc195c30ab8314ad22dc8e626d6f67f940f1e4957'

  bottle do
  end

  option :cxx11

  # apply this patch for C++11 mode
  # see https://git.gnome.org/browse/libsigc++2/commit/tests/test_cpp11_lambda.cc?id=cd600a31fbf8e76e25f4be4c10c0645f090a9b80
  patch :DATA if build.cxx11?

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
__END__
diff -u a/tests/test_cpp11_lambda.cc b/tests/test_cpp11_lambda.cc
--- a/tests/test_cpp11_lambda.cc
+++ b/tests/test_cpp11_lambda.cc
@@ -312,7 +312,7 @@

   //std::cout << (sigc::group(sigc::mem_fun(&bar::test), _1, _2, _3)) (sigc::ref(the_bar), 1, 2) << std::endl;
   result_stream << std::bind(std::mem_fn(&bar::test), std::placeholders::_1,
-    std::placeholders::_2, std::placeholders::_3)(std::ref(the_bar), 1, 2);
+    std::placeholders::_2, std::placeholders::_3)(the_bar, 1, 2);
   check_result("bar::test(int 1, int 2)6");

   // same functionality as bind
