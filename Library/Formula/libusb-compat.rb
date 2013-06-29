require 'formula'

class LibusbCompat < Formula
  homepage 'http://www.libusb.org/'
  url 'http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.4/libusb-compat-0.1.4.tar.bz2'
  sha256 'ed5bdd160c7b01ef767fb931a81b454f46226d1e2cf58502ced758d3e5a9fdc4'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
