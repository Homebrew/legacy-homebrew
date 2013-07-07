require 'formula'

class Flvstreamer < Formula
  homepage 'http://www.nongnu.org/flvstreamer/'
  url 'http://download.savannah.gnu.org/releases-noredirect/flvstreamer/source/flvstreamer-2.1c1.tar.gz'
  sha1 '07fac3dea65d8de8afbcc3c892d7830a90b66f10'

  def install
    system "make posix"
    bin.install 'flvstreamer', 'rtmpsrv', 'rtmpsuck', 'streams'
  end
end
