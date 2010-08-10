require 'formula'

class GitFlow <Formula
  url 'git://github.com/nvie/gitflow.git', :tag => '0.2.1'
  version '0.2.1'
  head 'git://github.com/nvie/gitflow.git', :branch => 'develop'

  homepage 'http://github.com/nvie/gitflow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
