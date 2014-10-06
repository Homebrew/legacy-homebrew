require 'formula'

class GitArchiveAll < Formula
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.9.tar.gz'
  sha1 '7b5e9439e9e5dd331f36d3eb1a79d16f89488c67'

  head 'https://github.com/Kentzo/git-archive-all.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
