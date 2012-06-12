require 'formula'

class GitFtp < Formula
  homepage 'https://github.com/resmo/git-ftp'
  url 'https://github.com/resmo/git-ftp/tarball/0.7.5'
  sha1 'e893bcf1c3f67a54529b2d4a404f0e3b5bc7696f'

  head 'https://github.com/resmo/git-ftp.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
