require "formula"

class Vimpager < Formula
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.01.tar.gz"
  sha256 "a890bd825025c3ffcf1aaa634ad523516a6a65dd4c327c925cd79c6329f2ece0"
  head "https://github.com/rkitover/vimpager.git"

  def install
    bin.install "vimcat"
    bin.install "vimpager"
    man1.install gzip("vimpager.1")
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end
end
