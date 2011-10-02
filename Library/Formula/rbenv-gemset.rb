require 'formula'

class RbenvGemset < Formula
  url 'https://github.com/jamis/rbenv-gemset/tarball/v0.2.1'
  homepage 'https://github.com/jamis/rbenv-gemset'
  md5 '21d6a809ea2232164a570b1fff13e8e4'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    Run the following command to complete the installation of rbenv-gemset:

        rbenv gemset install
    EOS
  end
end
