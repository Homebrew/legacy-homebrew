require 'formula'

class GitFtp < Formula
  homepage 'http://git-ftp.github.io/git-ftp'
  url 'https://github.com/git-ftp/git-ftp/archive/0.9.0.tar.gz'
  sha1 '37116c868b5fdd58136896b43542afdf3af71530'

  head 'https://github.com/git-ftp/git-ftp.git'

  option "with-manpage", "build and install the manpage (depends on pandoc)"

  depends_on "pandoc" => :build if build.with? "manpage"

  def install
    system "make", "prefix=#{prefix}", "install"
    if build.with? "manpage"
      system "make", "-C", "man", "man"
      man1.install "man/man1/git-ftp.1"
    end
  end
end
