require 'formula'

class Flvstreamer < Formula
  homepage 'http://www.nongnu.org/flvstreamer/'
  url 'http://download.savannah.gnu.org/releases-noredirect/flvstreamer/source/flvstreamer-2.1c1.tar.gz'
  md5 '4866387328ad89c957af90a2478e5556'

  def install
    system "make posix"
    bin.install 'flvstreamer', 'rtmpsrv', 'rtmpsuck', 'streams'
  end
end
