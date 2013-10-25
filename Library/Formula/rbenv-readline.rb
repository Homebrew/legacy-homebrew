require 'formula'

class RbenvReadline < Formula
  homepage 'https://github.com/tpope/rbenv-readline'
  url 'https://github.com/dfang/rbenv-readline/releases/download/v1.0.0/rbenv-readline.tar.gz'
  sha1 '97b86ac97802bbe7b881a80086fffd9d5f53056f'

  head 'https://github.com/tpope/rbenv-readline.git'

  depends_on 'rbenv'
  depends_on 'ruby-build'

  def install
    prefix.install Dir['*']
  end
end
