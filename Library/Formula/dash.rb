require 'formula'

class Dash <Formula
  url 'http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.6.1.tar.gz'
  homepage 'http://gondor.apana.org.au/~herbert/dash/'
  sha1 '06944456a1e3a2cbc325bffd0c898eff198b210a'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-libedit"
    system "make"
    system "make install"
  end
end
