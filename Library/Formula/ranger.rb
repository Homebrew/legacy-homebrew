require 'formula'

class Ranger < Formula
  url 'http://ranger.nongnu.org/ranger-1.5.2.tar.gz'
  md5 '75b1e15b50ecced0a337ae30741daa3b'
  homepage 'http://ranger.nongnu.org/'
  head 'git://git.savannah.nongnu.org/ranger.git', :using => :git

  def install
    man1.install 'doc/ranger.1'
    libexec.install ['ranger.py', 'ranger']
    bin.mkpath
    ln_s libexec+'ranger.py', bin+'ranger'
  end
end
