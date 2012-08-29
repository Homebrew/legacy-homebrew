require 'formula'

class Stgit < Formula
  homepage 'http://www.procode.org/stgit'
  url 'http://download.gna.org/stgit/stgit-0.16.tar.gz'
  md5 '73ca6a7469d30d9d69fa561e16abc2a8'

  def install
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end
end
