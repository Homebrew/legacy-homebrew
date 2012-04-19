require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://nongnu.org/ranger/ranger-1.5.3.tar.gz'
  md5 'ab90a2aa4d77cacbd47f45ed6b7c58f2'

  head 'git://git.savannah.nongnu.org/ranger.git'

  def install
    man1.install 'doc/ranger.1'
    libexec.install 'ranger.py', 'ranger'
    bin.install_symlink libexec+'ranger.py' => 'ranger'
  end
end
