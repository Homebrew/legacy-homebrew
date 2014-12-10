require 'formula'

class Sproxy < Formula
  homepage 'http://www.joedog.org/sproxy-home/'
  url 'http://download.joedog.org/sproxy/sproxy-1.02.tar.gz'
  sha1 'c218b3a49d3acc3aca39ac658b2013846ee7c5b9'

  bottle do
    sha1 "704405b86b25ab918c032f1acd1406c6d3cd9303" => :mavericks
    sha1 "406908571ae5c9ff66df74b06c28ae4b9ca46d8b" => :mountain_lion
    sha1 "0fcd7718cc091d48d74e72093a40acc9a650a208" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    # Makefile doesn't honor mandir, so move manpages post-install
    share.install prefix+'man'
  end
end
