require 'formula'

class Libsigcxx < Formula
  homepage 'http://libsigc.sourceforge.net'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.3/libsigc++-2.3.1.tar.xz'
  sha256 '67d05852b31fdb267c9fdcecd40b046a11aa54d884435e99e3c60dd20cd60393'

  bottle do
    sha1 "8e806e2532f2ef1a1a8bb936a1f54e34c20bda69" => :mavericks
    sha1 "2a522fa21082df0620b515dc4466dcb7eb0c5c6f" => :mountain_lion
    sha1 "328a7b8efcfd560caae155d3acf25087c2a05462" => :lion
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
