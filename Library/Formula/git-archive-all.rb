require 'formula'

class GitArchiveAll < Formula
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.6.zip'
  sha1 '6147f79c73a569bfd808b5c3e041d54a2bc5554d'

  head 'https://github.com/Kentzo/git-archive-all.git'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
