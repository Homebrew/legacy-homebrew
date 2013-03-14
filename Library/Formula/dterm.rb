require 'formula'

class Dterm < Formula
  homepage 'http://www.knossos.net.nz/resources/free-software/dterm/'
  url 'http://www.knossos.net.nz/downloads/dterm-0.3.tgz'
  sha1 'b7dd8cf8c0eb3ef43a32db6011361e886850390d'

  def install
    system "make"
    bin.install "dterm"
  end
end
