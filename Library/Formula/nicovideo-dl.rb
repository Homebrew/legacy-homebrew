require 'formula'

class NicovideoDl < Formula
  homepage 'http://sourceforge.jp/projects/nicovideo-dl/'
  url 'http://dl.sourceforge.jp/nicovideo-dl/56304/nicovideo-dl-0.0.20120212.tar.gz'
  sha1 '19f92570e01bd19a5a980e67985c0821e0af6ad5'

  def install
    bin.install 'nicovideo-dl'
  end

  test do
    system "#{bin}/nicovideo-dl",  "-v"
  end
end
