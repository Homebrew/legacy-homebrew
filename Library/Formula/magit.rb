require 'formula'

class Magit < Formula
  homepage 'https://github.com/magit/magit'
  url 'https://github.com/magit/magit/archive/1.2.1.tar.gz'
  sha1 '3faeaab35934951a746e3be834d0457ca99bdc01'

  head 'https://github.com/magit/magit.git'

  bottle do
    cellar :any
    sha1 "0c988c206dc40f76695c0b94bc930d6b2e4aefe0" => :yosemite
    sha1 "8d43e307fcbda7378087875f1b3296c0fc9aad20" => :mavericks
    sha1 "f13c6aab177ce0c9e9d90d4197f7719d92925b93" => :mountain_lion
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
