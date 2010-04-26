require 'formula'

class GitFlow <Formula
  if ARGV.include? "--HEAD"
    head 'git://github.com/nvie/gitflow.git', :branch => 'develop'
  else
    head 'git://github.com/nvie/gitflow.git', :tag => '0.2.1'
    version '0.2.1'
  end

  homepage 'http://github.com/nvie/gitflow'

  # You need git to install, since we install from a git repo
  # You also need git to run the scripts.
  # But we're not going to mark it as a dependency just yet:
  #   The user may have a non-brew git installed already.
  # depends_on 'git'

  def install
    system "make",  "prefix=#{prefix}", "install"
  end
end
