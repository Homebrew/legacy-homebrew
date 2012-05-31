require 'formula'

class Jbig2dec < Formula
  homepage 'http://jbig2dec.sourceforge.net'
  url 'http://ghostscript.com/~giles/jbig2/jbig2dec/jbig2dec-0.11.tar.gz'
  md5 '1f61e144852c86563fee6e5ddced63f1'

  def install
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/jbig2dec", '--version'
  end
end
