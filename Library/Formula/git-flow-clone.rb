require 'formula'

class GitFlowClone < Formula
  homepage 'https://github.com/ashirazi/git-flow-clone'
  url 'https://github.com/ashirazi/git-flow-clone/archive/0.1.2.zip'
  sha1 'dd3d31069f74e946c2ea3d7953d3652bd3c34cfb'
  
  depends_on 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

end
