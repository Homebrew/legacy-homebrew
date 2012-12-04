require 'formula'

class Daa2iso < Formula
  homepage 'http://aluigi.org/mytoolz.htm'
  url 'http://aluigi.org/mytoolz/daa2iso.zip'
  sha1 '24a73b2e61c4018d2b26ba79db744caa038070e1'

  version '0.1.7e'

  def install
    ENV.deparallelize
    
    cd("src") do
      system "make"
    end
  end

  def test
    system "daa2iso"
  end
end
