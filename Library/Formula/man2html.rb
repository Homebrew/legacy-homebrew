require 'formula'

class Man2html <Formula
  url 'http://hydra.nac.uci.edu/indiv/ehood/tar/man2html3.0.1.tar.gz'
  homepage 'http://hydra.nac.uci.edu/indiv/ehood/man2html.html'
  md5 '1c0d28c83225d0ebc845f2386c8f8384'

  def install
    bin.mkpath
    man1.mkpath
    system "/usr/bin/perl", "install.me", "-batch",
      "-binpath", bin,
      "-manpath", man
  end
end
