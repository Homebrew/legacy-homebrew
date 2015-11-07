class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://logcheck.alioth.debian.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  sha256 "c2d3fc323e8c6555e91d956385dbfd0f67b55872ed0f6a7ad8ad2526a9faf03a"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "b919397f55dcbab89df41e9ad83d6b5ff09f6f5d91e366b0eeaa627b3b8cfa9a" => :el_capitan
    sha256 "a72f565e1014a37e90498c52b6c67c0608c867e78ec2f0411803e57e2650ed88" => :yosemite
    sha256 "fe1817125f5fde6b259dfdfd70597e16f8189775ae78b9fd8f6821c4e1ea22b6" => :mavericks
  end

  def install
    inreplace "Makefile", "$(DESTDIR)/$(CONFDIR)", "$(CONFDIR)"

    system "make", "install", "--always-make", "DESTDIR=#{prefix}",
                   "SBINDIR=sbin", "BINDIR=bin", "CONFDIR=#{etc}/logcheck"
  end

  test do
    cp HOMEBREW_REPOSITORY/"README.md", testpath
    system "#{sbin}/logtail", "-f", "README.md"
  end
end
