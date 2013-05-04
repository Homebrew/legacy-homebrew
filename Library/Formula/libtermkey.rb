require 'formula'

class Libtermkey < Formula
  homepage 'http://www.leonerd.org.uk/code/libtermkey/'
  url 'http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.16.tar.gz'
  sha1 'd89557f8ba37f4710cdb7e35d294a5965149eda4'

  depends_on :libtool

  def install
    system "make", "PREFIX=#{prefix}", "LIBTOOL=glibtool"
    system "make", "install", "PREFIX=#{prefix}", "LIBTOOL=glibtool"
  end
end
