require 'formula'

class DfuUtil < Formula
  homepage 'http://dfu-util.gnumonks.org/'
  url 'http://dfu-util.gnumonks.org/releases/dfu-util-0.6.tar.gz'
  sha1 '9cb8d27427216f80679141b142be05222407ab95'

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
