require 'formula'

class Ranger < Formula
  url 'http://savannah.spinellicreations.com/ranger/releases/ranger-1.4.2.tar.gz'
  homepage 'http://ranger.nongnu.org/'
  md5 '93696d44fcf039a6e3aa9efa270f70c4'

  def install
    man1.install 'doc/ranger.1'
    libexec.install ['ranger.py', 'ranger']
    bin.mkpath
    ln_s libexec+'ranger.py', bin+'ranger'
  end
end
