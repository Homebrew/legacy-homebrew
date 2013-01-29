require 'formula'

class GitFlowClone < Formula
  homepage 'https://github.com/ashirazi/git-flow-clone'
  url 'https://github.com/ashirazi/git-flow-clone/archive/0.1.2.tar.gz'
  sha1 'd4d5c106ebd7de8abbee69f0b277ecdfe85e5b6d'

  depends_on 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
