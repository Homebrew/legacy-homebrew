require 'formula'

class GitFlowClone < Formula
  homepage 'https://github.com/ashirazi/git-flow-clone'
  url 'https://github.com/ashirazi/git-flow-clone/tarball/master', :tag => '0.1.0'
  sha1 '039361d7ec4ff6076daf18f0c8bf704d113824b3'
  version '0.1.0'
  depends_on 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

end
