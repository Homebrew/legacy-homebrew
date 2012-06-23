require 'formula'

class GitFtp < Formula
  homepage 'https://github.com/resmo/git-ftp'
  url 'https://github.com/resmo/git-ftp/tarball/0.8.0'
  md5 'd20043261ab5ca28804891b531e63c13'

  head 'https://github.com/resmo/git-ftp.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
