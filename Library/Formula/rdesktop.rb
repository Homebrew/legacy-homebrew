require 'formula'

class Rdesktop < Formula
  homepage 'http://www.rdesktop.org/'
  url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.1/rdesktop-1.8.1.tar.gz'
  sha1 '57bb41f98ddf9eeef875c613d790fee37971d0f8'

  depends_on :x11

  def install
    args = ["--prefix=#{prefix}",
            "--disable-credssp",
            "--disable-smartcard", # disable temporally before upstream fix
            "--with-openssl=#{MacOS.sdk_path}/usr",
            "--x-includes=#{MacOS::X11.include}"]
    system "./configure", *args
    system "make install"
  end
end
