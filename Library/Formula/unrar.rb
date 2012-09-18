require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-4.2.4.tar.gz'
  sha1 '1cc29603fb4e4df16a3aa9bfc7da1afaf0923259'

  def install
    system "make --makefile makefile.unix"
    bin.install 'unrar'
    prefix.install 'license.txt' => 'COPYING'
    prefix.install 'readme.txt' => 'README'
  end
end
