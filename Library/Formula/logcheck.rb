class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://logcheck.alioth.debian.org/"
  url "https://mirrors.kernel.org/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  sha256 "c2d3fc323e8c6555e91d956385dbfd0f67b55872ed0f6a7ad8ad2526a9faf03a"

  bottle do
    cellar :any
    revision 1
    sha256 "cd8a2d7c4a28b13047fb89624bfcbc5dad359545c1cc80cd1b9e79018f368372" => :yosemite
    sha256 "4757698c916095d0f9a29c0e42e55b6c5c24a3a972a569ea2eae2e795f0a59ba" => :mavericks
    sha256 "1a005750f43b2bc64f8031233470f827c10fb567845140d5b1e91e668cc249af" => :mountain_lion
  end

  def install
    inreplace "Makefile", "$(DESTDIR)/$(CONFDIR)", "$(CONFDIR)"

    system "make", "install", "--always-make", "DESTDIR=#{prefix}",
                   "SBINDIR=sbin", "BINDIR=bin", "CONFDIR=#{etc}/logcheck"
  end

  test do
    system "#{sbin}/logtail", "-f", "#{HOMEBREW_REPOSITORY}/README.md"
  end
end
