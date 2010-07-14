require 'formula'

class GitFlow <Formula
  if ARGV.include? "--HEAD"
    head 'git://github.com/nvie/gitflow.git', :branch => 'develop'
  else
    head 'git://github.com/nvie/gitflow.git', :tag => '0.2.1'
    version '0.2.1'
  end

  homepage 'http://github.com/nvie/gitflow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
