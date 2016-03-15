class Connect < Formula
  desc "provides SOCKS and HTTPS proxy support to SSH."
  homepage "https://bitbucket.org/gotoh/connect/wiki/Home"
  url "https://bitbucket.org/gotoh/connect/get/1.104.tar.gz"
  sha256 "6ca5291ea8e4a402d875a5507ac78d635373584fd1912f2838b93e03b99730c8"

  def install
    # A pull request has been submitted upstream to resolve issues with the
    # Makefile producing errors when executed on OS X, see:
    # https://bitbucket.org/gotoh/connect/pull-requests/5/updates-to-allow-for-cross-compiling/diff
    # 
    # This simpler solution of simply removing the call to ver solves the 
    # problem for installation on OS X until such time as the above pull 
    # request is merged.
    inreplace "Makefile", "WINVER := $(shell ver)", ""
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
