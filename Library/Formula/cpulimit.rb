class Cpulimit < Formula
  desc "CPU usage limiter"
  homepage "https://github.com/opsengine/cpulimit"
  url "https://github.com/opsengine/cpulimit/archive/v0.2.tar.gz"
  sha256 "64312f9ac569ddcadb615593cd002c94b76e93a0d4625d3ce1abb49e08e2c2da"

  head "https://github.com/opsengine/cpulimit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d7320465152a12ba75ce924beada5a3ce365b14becaa75e08ee8334c2cb2f6a" => :el_capitan
    sha256 "7ff9d929c5a1178b250b756cefcbecc4b202c72f03073e9eb43f4a47420930a8" => :yosemite
    sha256 "c24a495cd69c62693bcb0bd2a44c41c5bca84f0b9754019681816c1d2b47fe3e" => :mavericks
  end

  def install
    system "make"
    bin.install "src/cpulimit"
  end

  test do
    system "#{bin}/cpulimit", "--limit=10", "ls"
  end
end
