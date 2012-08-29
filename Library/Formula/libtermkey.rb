require 'formula'

class Libtermkey < Formula
  homepage 'http://www.leonerd.org.uk/code/libtermkey/'
  url 'http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.13.tar.gz'
  md5 'f3bd5912c7a0d9b3eede126528c25665'

  def install
    system "make", "PREFIX=#{prefix}", "LIBTOOL=glibtool"
    system "make", "install", "PREFIX=#{prefix}", "LIBTOOL=glibtool"
  end
end
