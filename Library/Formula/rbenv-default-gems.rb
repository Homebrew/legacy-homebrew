require 'formula'

class RbenvDefaultGems < Formula
  homepage 'https://github.com/sstephenson/rbenv-default-gems'
  url 'https://github.com/sstephenson/rbenv-default-gems/archive/v1.0.0.tar.gz'
  sha1 'e79c7073909e24e866df49cf9eb3f18aa8872842'

  head 'https://github.com/sstephenson/rbenv-default-gems.git'

  depends_on 'rbenv'
  depends_on 'ruby-build'

  def install
    prefix.install Dir['*']
  end
end
