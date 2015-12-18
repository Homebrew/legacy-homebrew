class WaitOn < Formula
  desc "Provides shell scripts with access to kqueue(3)"
  homepage "https://www.freshports.org/sysutils/wait_on/"
  url "http://distcache.freebsd.org/ports-distfiles/wait_on-1.1.tar.gz"
  sha256 "d7f40655f5c11e882890340826d1163050e2748de66b292c15b10d32feb6490f"

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "wait_on"
    man1.install "wait_on.1.gz"
  end

  test do
    system "#{bin}/wait_on", "-v"
  end
end
