require 'formula'

class GitFtp < Formula
  homepage 'http://git-ftp.github.io/git-ftp'
  url 'https://github.com/git-ftp/git-ftp/archive/1.0.0.tar.gz'
  sha1 '69df312a1e0cbb1224ec7571c4b83113211b5a4f'

  head 'https://github.com/git-ftp/git-ftp.git'

  bottle do
    cellar :any
    sha1 "b509c296643f9b4725f12673739d2bd9e63b7cd4" => :yosemite
    sha1 "f150cef49610efdbbfb98560c11b09dbf61f2d3e" => :mavericks
    sha1 "d27bdf1dbd1d3e9f01e2a34e7cffcea06e3d799b" => :mountain_lion
  end

  option "with-manpage", "build and install the manpage (depends on pandoc)"

  depends_on "curl" => [:optional, "with-libssh2"]
  depends_on "pandoc" => :build if build.with? "manpage"

  def install
    system "make", "prefix=#{prefix}", "install"
    if build.with? "manpage"
      system "make", "-C", "man", "man"
      man1.install "man/man1/git-ftp.1"
    end
  end
end
