require 'formula'

class Vimpager < Formula
  homepage 'https://github.com/rkitover/vimpager'
  url 'https://github.com/rkitover/vimpager/tarball/1.8.0'
  sha1 '15a13fa1ec2eaf42b63433c4ae8f365806dc1f31'
  head 'https://github.com/rkitover/vimpager.git'

  def install
    inreplace 'vimpager.1', '~/bin/', ''

    bin.install 'vimcat'
    bin.install 'vimpager'
    man1.install gzip('vimpager.1')
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end
