require 'formula'

class Jbig2dec < Formula
  homepage 'http://jbig2dec.sourceforge.net'
  url 'http://sourceforge.net/projects/jbig2dec/files/jbig2dec/0.11/jbig2dec-0.11.tar.gz'
  sha1 '349cd765616db7aac1f4dd1d45957d1da65ea925'

  def install
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system "#{bin}/jbig2dec", '--version'
  end
end
