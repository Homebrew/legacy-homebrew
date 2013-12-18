require 'formula'

class Man2html < Formula
  homepage 'http://www.oac.uci.edu/indiv/ehood/man2html.html'
  url 'http://www.oit.uci.edu/indiv/ehood/tar/man2html3.0.1.tar.gz'
  sha1 '18b617783ce59491db984d23d2b0c8061bff385c'

  def install
    bin.mkpath
    man1.mkpath
    system "/usr/bin/perl", "install.me", "-batch",
                            "-binpath", bin,
                            "-manpath", man
  end
end
