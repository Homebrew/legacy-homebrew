require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://nongnu.org/ranger/ranger-1.5.5.tar.gz'
  sha1 '1d18346f4a237b74a85d1214d34a956b3b29645a'

  head 'git://git.savannah.nongnu.org/ranger.git'

  def install
    man1.install 'doc/ranger.1'
    libexec.install 'ranger.py', 'ranger'
    bin.install_symlink libexec+'ranger.py' => 'ranger'
  end
end
