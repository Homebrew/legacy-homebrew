require 'formula'

class Libgadu < Formula
  homepage 'http://toxygen.net/libgadu/'
  url 'http://toxygen.net/libgadu/files/libgadu-1.9.0-rc2.tar.gz'
  md5 '2d2a96a98e33d3a0055bc76f67a19f04'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-debug', '--disable-dependency-tracking'
    system 'make install'
  end
end
