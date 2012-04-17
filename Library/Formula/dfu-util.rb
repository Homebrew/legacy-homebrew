require 'formula'

class DfuUtil < Formula
  url 'http://dfu-util.gnumonks.org/releases/dfu-util-0.5.tar.gz'
  homepage 'http://dfu-util.gnumonks.org/'
  md5 '36426e5eaedec4866576e6b3bd3eeafc'

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

