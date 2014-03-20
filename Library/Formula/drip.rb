require 'formula'

class Drip < Formula
  homepage 'https://github.com/flatland/drip'
  url 'https://github.com/flatland/drip/archive/0.2.4.tar.gz'
  sha1 '6c3c4ea6395e542815c3d5a44612748cc4f1f85e'

  def install
    system 'make'
    libexec.install %w{ bin src Makefile }
    bin.install_symlink libexec/'bin/drip'
  end
end
