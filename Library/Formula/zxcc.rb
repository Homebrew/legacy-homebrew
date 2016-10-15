require 'formula'

class Zxcc < Formula
  homepage 'http://www.seasip.info/Unix/Zxcc/'
  url 'http://www.seasip.info/Unix/Zxcc/zxcc-0.5.6.tar.gz'
  sha1 '9b4116e12895be99362dabd87067ae50f193ea9d'

  depends_on :libtool

  def install
    args = [
      "--prefix=#{prefix}",
      "--build=i386"  # configure fails with x86_64 or -apple-darwin
    ]

    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end

  def patches
    DATA
  end

  test do
    code = [
      0x11, 0x0b, 0x01,   # 0100 ld de,010bh
      0x0e, 0x09,         # 0103 ld c,cwritestr
      0xcd, 0x05, 0x00,   # 0105 call bdos
      0xc3, 0x00, 0x00,   # 0108 jp warm
      0x48, 0x65, 0x6c,   # 010b db "Hel"
      0x6c, 0x6f, 0x24    # 010e db "lo$"
    ].pack("c*")

    path = testpath/"hello.com"
    path.open("wb") { |f| f.write code }

    output = `#{bin}/zxcc #{path}`.strip
    assert_equal "Hello", output
    assert_equal 0, $?.exitstatus
  end
end

__END__
diff -u ./cpmredir/include/cpmredir.h.orig ./cpmredir/include/cpmredir.h
--- ./cpmredir/include/cpmredir.h.orig 2013-12-25 14:19:04.000000000 -0800
+++ ./cpmredir/include/cpmredir.h 2013-12-25 14:20:16.000000000 -0800
@@ -44,6 +44,11 @@
 extern "C" {
 #endif

+#ifdef __APPLE__
+ #include <sys/param.h>
+ #include <sys/mount.h>
+#endif
+
