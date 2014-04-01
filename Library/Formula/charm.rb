require "formula"

class Charm < Formula
  homepage "http://ljcharm.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ljcharm/charm/charm-1.9.2/charm-1.9.2.tar.gz"
  sha1 "6f687a302baf88f5bdf4f5e5fad7ff8d2d21ff18"

  depends_on :python

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/charm", "--help"
  end

  def caveats; <<-EOS.undent
    Charm requires a .charmrc file in your home directory. See:
        #{HOMEBREW_PREFIX}/share/doc/charm/sample.charmrc
    EOS
  end
end
