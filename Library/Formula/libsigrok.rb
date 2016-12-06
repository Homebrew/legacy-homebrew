require 'formula'

class Libsigrok < Formula
  url 'http://downloads.sourceforge.net/project/sigrok/source/libsigrok/libsigrok-0.1.1.tar.gz'
  homepage 'http://sigrok.org'
  md5 '285c0b69aa3d36a431bf752c4f70c755'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libusb'
  depends_on 'libzip'
  depends_on 'libftdi'

  skip_clean :all

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-alsa"
    system "make install"
  end
end
