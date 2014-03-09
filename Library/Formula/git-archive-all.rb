require 'formula'

class GitArchiveAll < Formula
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.8.tar.gz'
  sha1 'e20f679330a7cba80a9cbfca8b0b7519d04de2f2'

  head 'https://github.com/Kentzo/git-archive-all.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
