class Trend < Formula
  desc "a general-purpose, efficient trend graph"
  homepage "http://www.thregr.org/~wavexx/software/trend/"
  url "http://www.thregr.org/~wavexx/software/trend/releases/trend-1.2.tar.gz"
  sha256 "40b0f58101801c9373d2b1d990eb327a4582e9a96e4eb2b43faf87346f9dd64f"

  depends_on :x11
  depends_on 'freeglut'

  def install
    ENV.deparallelize

    Dir.chdir 'src'
    system "make"
    bin.install "trend"

    Dir.chdir '..'
    man1.install 'trend.1'
  
    doc.install 'AUTHORS', 'NEWS', 'THANKS', 'COPYING', 'README', 'TODO'

  end

  test do
    system "echo {1..5} {4..2} {3..10} | -FD - 20x1 src/trend"
  end
end
