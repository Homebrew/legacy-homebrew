require "formula"

class IrssiOtr < Formula
  homepage "http://irssi-otr.tuxfamily.org/"
  url "ftp://download.tuxfamily.org/irssiotr/irssi-otr-0.3.tar.gz"
  sha1 "5b831dd64e7d84fcda45219b71f017233a6c327b"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :python => :build
  depends_on "glib"
  depends_on "libotr"
  depends_on "irssi"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      * For Irssi to find irssi-otr, symlink it into your personal config:

      mkdir -p ~/.irssi/modules
      ln -s #{lib}/irssi/modules/libotr.so ~/.irssi/modules/
    EOS
  end

  test do
    system "test", "-f", "#{lib}/irssi/modules/libotr.so"
  end
end
