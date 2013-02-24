require 'formula'

class Daemontools < Formula
  homepage 'http://cr.yp.to/daemontools.html'
  url 'http://cr.yp.to/daemontools/daemontools-0.76.tar.gz'
  sha1 '70a1be67e7dbe0192a887905846acc99ad5ce5b7'

  def install
    cd "daemontools-0.76" do
      system "package/compile"
      bin.install Dir["command/*"]
    end
  end
end
