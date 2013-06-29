require 'formula'

class Stgit < Formula
  homepage 'http://www.procode.org/stgit'
  url 'http://download.gna.org/stgit/stgit-0.16.tar.gz'
  sha1 '10b62d080a4c34c2dd11de4d1c800f62b9e5018c'

  def install
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end
end
