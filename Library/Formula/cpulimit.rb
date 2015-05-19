class Cpulimit < Formula
  desc "CPU usage limiter"
  homepage "https://github.com/opsengine/cpulimit"
  url "https://github.com/opsengine/cpulimit/archive/v0.1.tar.gz"
  sha256 "6e653150aae18dd72f7dd93d92ee5f200eb8fef89e6c0bed28a2e3233dc29f23"

  head "https://github.com/opsengine/cpulimit.git"

  def install
    system "make"
    bin.install "src/cpulimit"
  end

  test do
    system *%W[#{bin}/cpulimit -l 10 ls]
  end
end
