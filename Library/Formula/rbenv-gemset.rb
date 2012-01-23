require 'formula'

class RbenvGemset < Formula
  url 'https://github.com/jamis/rbenv-gemset/tarball/v0.3.0'
  homepage 'https://github.com/jamis/rbenv-gemset'
  md5 '884d5ddcd4a9e9e88948a23c686e2725'

  head 'https://github.com/jamis/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
