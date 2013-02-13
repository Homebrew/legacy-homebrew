require 'formula'

class RbenvDefaultGems < Formula
  homepage 'https://github.com/sstephenson/rbenv-default-gems'
  url 'https://github.com/sstephenson/rbenv-default-gems/tarball/v1.0.0'
  sha1 '31789539ad0e69c2b9e2ec0da1d9acb8fba8b2bc'

  head 'https://github.com/sstephenson/rbenv-default-gems.git'

  depends_on 'rbenv'
  depends_on 'ruby-build'

  def install
    prefix.install Dir['*']
  end
end
