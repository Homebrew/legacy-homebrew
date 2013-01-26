require 'formula'

class Setres < Formula
  homepage 'https://github.com/jaykru/setres/'
  url 'https://github.com/jaykru/setres/archive/master.zip'
  sha1 '6a983842149152e1f204cb5d3f8247013cd3a276'
  version '1.0'

  def install
    bin.install "setres"
  end

  def test
    system "#{bin}/setres"
  end

  def caveats; <<-EOS.undent
    Read https://github.com/jaykru/setres/ for more information
    Usage example: setres 2880 1800
    EOS
  end
end
