require 'formula'

class Ranger < Formula
  url 'http://git.savannah.gnu.org/cgit/ranger.git/snapshot/ranger-1.4.3.tar.gz'
  homepage 'http://ranger.nongnu.org/'
  md5 '90eccff2305a9500181c78fb6803a621'

  def install
    man1.install 'doc/ranger.1'
    libexec.install ['ranger.py', 'ranger']
    bin.mkpath
    ln_s libexec+'ranger.py', bin+'ranger'
  end
end
