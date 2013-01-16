require 'formula'

class GambitBlackhole < Formula
  homepage 'http://gambitscheme.org/wiki/index.php/Black_Hole'
  head 'git://github.com/pereckerdal/blackhole.git'

  depends_on 'gambit-scheme'

  def install
    system "./compile.sh"
    mkdir "#{prefix}/share"
    system "find . |cpio -p \"#{prefix}/share\""
    mkdir "#{prefix}/bin" do
      ln_sf "../share/bh", '.'
    end
  end

  def test
    system "bh help"
  end
end
