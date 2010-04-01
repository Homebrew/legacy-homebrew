require 'formula'

class Webkit2png <Formula
  head 'git://github.com/paulhammond/webkit2png.git'
  homepage 'http://www.paulhammond.org/webkit2png/'
  md5 ''

  def install
    bin.install 'webkit2png'
  end
end
