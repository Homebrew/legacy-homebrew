require 'formula'

class GitFlowClone < Formula
  homepage 'https://github.com/ashirazi/git-flow-clone'
  url 'https://github.com/ashirazi/git-flow-clone.git', :tag => '0.1.1'
  sha1 'a5df4bdee240a16013fbc5969f834382f6135226'
  version '0.1.1'
  depends_on 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

end
