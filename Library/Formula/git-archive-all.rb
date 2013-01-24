require 'formula'

class GitArchiveAll < Formula
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.4.2.zip'
  sha1 'd2703fdc1061e23c4e9e76b6332d6db38ebe7c6d'

  head 'https://github.com/Kentzo/git-archive-all.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
