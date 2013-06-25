require 'formula'

class Watch < Formula
  homepage 'https://github.com/whit537/watch'
  url 'https://github.com/whit537/watch/archive/0.3.0.tar.gz'
  version '0.3.0'
  sha1 '1b355d16d729d5fe4c0ce90ec92b45946cfa4a5a'

  def install
    bin.install "watch"
    man1.install "watch.1"
  end

  def test
    system "#{bin}/watch", "-v"
  end
end
