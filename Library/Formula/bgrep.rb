require 'formula'

class Bgrep < Formula
  url 'https://github.com/tmbinc/bgrep/tarball/bgrep-0.2'
  homepage 'https://github.com/tmbinc/bgrep'
  md5 '0f5b3debbb502b196ef63e277660bccc'

  def install
    system "#{ENV.cc} #{ENV.cflags} -o bgrep bgrep.c"
    bin.install "bgrep"
  end
end
