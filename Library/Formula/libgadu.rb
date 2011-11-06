require 'formula'

class Libgadu < Formula
  homepage 'http://toxygen.net/libgadu/'
  url 'http://toxygen.net/libgadu/files/libgadu-1.11.0.tar.gz'
  md5 'c779891298ce5d081c1e871e1e5b256d'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-debug', '--disable-dependency-tracking'
    system 'make install'
  end
end
