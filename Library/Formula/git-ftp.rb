require 'formula'

class GitFtp < Formula
  homepage 'https://github.com/resmo/git-ftp'
  url 'https://github.com/resmo/git-ftp/tarball/0.7.1'
  md5 '55512e24c8be66e333da98bb3c3e2b10'
  head 'https://github.com/resmo/git-ftp.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
