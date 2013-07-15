require 'formula'

class DfuUtil < Formula
  homepage 'http://dfu-util.gnumonks.org/'
  url 'http://dfu-util.gnumonks.org/releases/dfu-util-0.7.tar.gz'
  sha1 'a6f621a17a164bd86d2752e2fcd3903f94a8925b'

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
