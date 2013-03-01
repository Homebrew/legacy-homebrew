require 'formula'

class Bgrep < Formula
  homepage 'https://github.com/tmbinc/bgrep'
  url 'https://github.com/tmbinc/bgrep/archive/bgrep-0.2.tar.gz'
  sha1 '37f29f95397730dcd8760a0bac33ba167ac7d998'

  def install
    system "#{ENV.cc} #{ENV.cflags} -o bgrep bgrep.c"
    bin.install "bgrep"
  end
end
