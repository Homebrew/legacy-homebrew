require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/2.2.2.tar.gz'
  sha1 'e13ebcea4d88137c788363daafae546b0ccdbf19'

  def install
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/}
  end
end
