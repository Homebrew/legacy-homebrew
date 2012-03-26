require 'formula'

class Daemontools < Formula
  homepage 'http://cr.yp.to/daemontools.html'
  url 'http://cr.yp.to/daemontools/daemontools-0.76.tar.gz'
  md5 '1871af2453d6e464034968a0fbcb2bfc'

  def install
    cd "daemontools-0.76" do
      system "package/compile"
      bin.install Dir["command/*"]
    end
  end
end
