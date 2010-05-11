require 'formula'

class Webkit2png <Formula
  url 'http://github.com/paulhammond/webkit2png/tarball/9c4265a82ebfcec200fca8de39fb970e5aae0a3d'
  version '0.5'
  homepage 'http://www.paulhammond.org/webkit2png/'
  sha1 '1112d3f7e5fac5e1bfef11f38626d09536957310'

  def install
    bin.install 'webkit2png'
  end
end
