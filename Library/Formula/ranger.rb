require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://nongnu.org/ranger/ranger-1.6.1.tar.gz'
  sha1 'ac66644b362c6ed5b6f2127af799e12d8993f3b8'

  head 'git://git.savannah.nongnu.org/ranger.git'

  def install
    man1.install 'doc/ranger.1'
    libexec.install 'ranger.py', 'ranger'
    bin.install_symlink libexec+'ranger.py' => 'ranger'
  end
end
