require 'formula'

class GitFtp < Formula
  homepage 'http://git-ftp.github.io/git-ftp'
  url 'https://github.com/git-ftp/git-ftp/archive/0.9.0.tar.gz'
  sha1 '37116c868b5fdd58136896b43542afdf3af71530'

  head 'https://github.com/git-ftp/git-ftp.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
