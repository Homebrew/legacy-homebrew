require 'formula'

class Ranger < Formula
  homepage 'http://ranger.nongnu.org/'
  url 'http://nongnu.org/ranger/ranger-1.6.0.tar.gz'
  sha1 'dc40ccf941b15bcd1654b32c9b55de18b0840e30'

  head 'git://git.savannah.nongnu.org/ranger.git'

  def install
    man1.install 'doc/ranger.1'
    libexec.install 'ranger.py', 'ranger'
    bin.install_symlink libexec+'ranger.py' => 'ranger'
  end
end
