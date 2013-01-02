require 'formula'

class Dterm < Formula
  url 'http://www.knossos.net.nz/downloads/dterm-0.3.tgz'
  homepage 'http://www.knossos.net.nz/dterm.html'
  sha1 'b7dd8cf8c0eb3ef43a32db6011361e886850390d'

  def install
    system "make"
    bin.install "dterm"
  end
end
