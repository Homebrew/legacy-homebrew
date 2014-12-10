require 'formula'

class Topgit < Formula
  homepage 'https://github.com/greenrd/topgit'
  url 'https://github.com/greenrd/topgit/archive/topgit-0.9.tar.gz'
  sha1 '619572db467259f9b56474b542f428dc52e0fbc9'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
