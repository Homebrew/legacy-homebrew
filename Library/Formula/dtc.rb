require "formula"

class Dtc < Formula
  homepage "http://www.devicetree.org/"
  url "http://ftp.debian.org/debian/pool/main/d/device-tree-compiler/device-tree-compiler_1.4.0+dfsg.orig.tar.gz"
  sha1 "2f9697aa7dbc3036f43524a454bdf28bf7e0f701"

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
  end

  test do
    (testpath/'test.dts').write <<-EOS.undent
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
