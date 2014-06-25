require "formula"

class Vimpager < Formula
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/1.8.9.tar.gz"
  sha1 "332a84fec5bd2a4c2dae518d52b310dcaa49f417"
  head "https://github.com/rkitover/vimpager.git"

  def install
    inreplace "vimpager.1", "~/bin/", ""

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
