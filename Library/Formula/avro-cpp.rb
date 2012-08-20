require 'formula'

class AvroCpp < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.1/cpp/avro-cpp-1.7.1.tar.gz'
  sha1 'dc4e45be1821552ea90d4962a1f7277c33b5c5b7'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def patches
    # Fix clang++ compilation issue (fixed in avro-development branch)
    DATA
  end
end
__END__
--- avro/test/unittest.cc	2012-07-12 12:27:30.000000000 -0700
+++ avro/test/unittest.cc	2012-08-20 14:30:38.000000000 -0700
@@ -332,7 +332,7 @@
     void readFixed(Parser &p) {

         boost::array<uint8_t, 16> input;
-        p.readFixed<16>(input);
+        p.template readFixed<16>(input);
         BOOST_CHECK_EQUAL(input.size(), 16U);

         for(int i=0; i< 16; ++i) {
