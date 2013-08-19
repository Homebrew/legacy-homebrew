require 'formula'

class Nutch < Formula
  homepage 'http://nutch.apache.org/'
  url 'http://mirror.reverse.net/pub/apache/nutch/2.2.1/apache-nutch-2.2.1-src.tar.gz'
  sha1 'c5d5d535a87d518aad41e89047c1eeb4331b74d2'

  def install
    system "ant runtime"
    prefix.install Dir['runtime/']
    bin.install_symlink prefix/'runtime/local/bin/nutch'
  end

  test do
    system "#{bin}/nutch"
  end
end
