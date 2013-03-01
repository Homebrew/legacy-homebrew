require 'formula'

class GitArchiveAll < Formula
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.5.zip'
  sha1 '2eda5684a64bd22761e8ba9229d16862108a8f30'

  head 'https://github.com/Kentzo/git-archive-all.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
