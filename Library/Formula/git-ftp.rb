require 'formula'

class GitFtp < Formula
  homepage 'https://github.com/resmo/git-ftp'
  url 'https://github.com/resmo/git-ftp/tarball/0.8.0'
  sha1 '68368fbe74a11bab0f248f2a512f034a8d4b5133'

  head 'https://github.com/resmo/git-ftp.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
