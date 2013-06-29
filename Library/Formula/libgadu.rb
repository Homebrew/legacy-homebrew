require 'formula'

class Libgadu < Formula
  homepage 'http://toxygen.net/libgadu/'
  url 'http://toxygen.net/libgadu/files/libgadu-1.11.2.tar.gz'
  sha1 '0e13836416b49212d5f17a74d8c2e72c5f915238'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-debug', '--disable-dependency-tracking'
    system 'make install'
  end
end
