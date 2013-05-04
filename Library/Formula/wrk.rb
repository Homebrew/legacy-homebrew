require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/1.2.0.tar.gz'
  sha1 '69e1ddb34c35a901bbf5adc7d285f1d0a881356d'

  def install
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/}
  end
end
