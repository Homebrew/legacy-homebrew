require 'formula'

class Ranger < Formula
  url 'http://ranger.nongnu.org/ranger-1.4.3.tar.gz'
  homepage 'http://ranger.nongnu.org/'
  md5 '51bfaccd6b58b0d25a9c9566dc8cbd46'

  def install
    man1.install 'doc/ranger.1'
    libexec.install ['ranger.py', 'ranger']
    bin.mkpath
    ln_s libexec+'ranger.py', bin+'ranger'
  end
end
