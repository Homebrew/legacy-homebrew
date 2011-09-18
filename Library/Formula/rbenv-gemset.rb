require 'formula'

class RbenvGemset < Formula
  url 'https://github.com/jamis/rbenv-gemset/tarball/v0.2.0'
  homepage 'https://github.com/jamis/rbenv-gemset'
  md5 '850c305de2037138adec7e97576a6af9'

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
