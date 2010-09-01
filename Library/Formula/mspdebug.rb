require 'formula'

class Mspdebug <Formula
  url 'http://downloads.sourceforge.net/project/mspdebug/mspdebug-0.10.tar.gz'
  md5 '6537f6666451a82422d6a5b01ba48e9c'
  homepage 'http://mspdebug.sf.net/'
  head 'git://mspdebug.git.sourceforge.net/gitroot/mspdebug/mspdebug'

  depends_on 'libusb'
  depends_on 'libusb-compat'
  depends_on 'libelf'

  def install
    ENV["PREFIX"] = prefix
    # Don't assume MacPorts:
    inreplace "Makefile", "/opt", "/usr"
    system "make install"
  end
end
