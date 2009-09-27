require 'brewkit'

class Hercules <Formula
  url 'http://www.hercules-390.org/hercules-3.06.tar.gz'
  homepage 'http://www.hercules-390.org/'
  md5 '3a356b251e2b7fc49ac2b7244d12d50b'

 depends_on 'gawk'

  def install
    # Since Homebrew optimizes for us, tell Hercules not to.
    # (It gets it wrong anyway.)
    system "./configure", "--prefix=#{prefix}", 
                          "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--enable-optimization=no"
    system "make"
    system "make install"
  end
end
