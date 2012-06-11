require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://nongnu.org/ranger/ranger-1.5.4.tar.gz'
  sha1 '6cf42596e18e45edcfaa90e8c9601934fcaee047'

  head 'git://git.savannah.nongnu.org/ranger.git'

  def install
    man1.install 'doc/ranger.1'
    libexec.install 'ranger.py', 'ranger'
    bin.install_symlink libexec+'ranger.py' => 'ranger'
  end
end
