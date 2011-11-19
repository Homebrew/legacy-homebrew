require 'formula'

class Vimpager < Formula
  homepage 'https://github.com/rkitover/vimpager'
  url 'https://github.com/rkitover/vimpager/tarball/1.6.0'
  md5 '9fe26c4651a93800b698b4110a3c4ad8'
  head 'https://github.com/rkitover/vimpager.git'

  def install
    inreplace 'vimpager.1', '~/bin/', ''

    bin.install 'vimpager'
    man1.install gzip('vimpager.1')
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end
