require 'formula'

class Picolisp <Formula
  url 'http://www.software-lab.de/picoLisp-3.0.4.tgz'
  homepage 'http://www.software-lab.de/down.html'
  md5 '02dcb487eb276939cea827b7a1384ce9'

  def install
    system "cd src ; make picolisp"
    bin.install('bin/picolisp');
  end
end
