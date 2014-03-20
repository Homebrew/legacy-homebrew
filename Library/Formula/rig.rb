require "formula"

class Rig < Formula
  homepage "http://rig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rig/rig/1.11/rig-1.11.tar.gz"
  sha1 "53a26676c35ba0c1112e1906deebb33a41dd5e95"

  def install
    system "make"
    bin.install 'rig'
    (share/'rig').install Dir['data/*']
  end

  test do
    system "#{bin}/rig"
  end
end
