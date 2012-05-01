require 'formula'

class GitFtp < Formula
  homepage 'https://github.com/resmo/git-ftp'
  url 'https://github.com/resmo/git-ftp/tarball/0.7.3'
  md5 'b5fdc018ddc62258ad6885dce35babb6'

  head 'https://github.com/resmo/git-ftp.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
