require 'formula'

class Wrk < Formula
  homepage 'https://github.com/wg/wrk'
  url 'https://github.com/wg/wrk/archive/3.0.1.tar.gz'
  sha1 'de18133a99ee13d572124983e688536bd82f93ea'

  head 'https://github.com/wg/wrk.git'

  def install
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -r 1 -t 1 http://www.github.com/}
  end
end
