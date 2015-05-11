class Vimpager < Formula
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.02.tar.gz"
  sha256 "d0e59b33b1c21f996992ddeeaf87a63f6494b60443847acf28e3f3376acd6a05"
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
