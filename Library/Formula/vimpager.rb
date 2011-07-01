require 'formula'

class Vimpager < Formula
  homepage 'https://github.com/rkitover/vimpager'
  url 'https://github.com/rkitover/vimpager/tarball/1.5.4'
  sha256 '738c22ad5067fc872a913ade8c6def92f6b6d7128f20edc939f51882bac40862'
  head 'https://github.com/rkitover/vimpager', :using => :git

  def install
    inreplace "vimpager.1", "~/bin/", ""

    bin.install 'vimpager'
    man1.install 'vimpager.1'
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end
