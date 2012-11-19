require 'formula'

class Bgrep < Formula
  url 'https://github.com/tmbinc/bgrep/tarball/bgrep-0.2'
  homepage 'https://github.com/tmbinc/bgrep'
  sha1 'a43be236e437779a941ebfbeca8a3abf7075182d'

  def install
    system "#{ENV.cc} #{ENV.cflags} -o bgrep bgrep.c"
    bin.install "bgrep"
  end
end
