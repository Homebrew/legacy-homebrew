require 'formula'

class GitFtp < Formula
  homepage 'http://git-ftp.github.io/git-ftp'
  url 'https://github.com/git-ftp/git-ftp/archive/1.0.1.tar.gz'
  sha1 'ee0ff7525a88aafffe7e09b6cb95d6dde6bacf93'

  head 'https://github.com/git-ftp/git-ftp.git', :branch => 'develop'

  bottle do
    cellar :any
    sha1 "a50d3779a05f20c022634e521dbac54db3cb8bba" => :yosemite
    sha1 "9ecb3e11463fb1ec6d961747e24be242fc8213ea" => :mavericks
    sha1 "90bd8f913a3c01f8cdc55d77dd8ed455354bfa52" => :mountain_lion
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
