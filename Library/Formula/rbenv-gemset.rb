require 'formula'

class RbenvGemset < Formula
  homepage 'https://github.com/jamis/rbenv-gemset'
  url 'https://github.com/jamis/rbenv-gemset/archive/v0.3.0.tar.gz'
  sha1 '9c40f7efc3fea6e455adc3971d8e3ddd191e7560'

  head 'https://github.com/jamis/rbenv-gemset.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end
end
