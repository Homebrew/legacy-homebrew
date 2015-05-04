class Logcheck < Formula
  homepage "https://logcheck.alioth.debian.org/"
  url "https://mirrors.kernel.org/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  sha256 "c2d3fc323e8c6555e91d956385dbfd0f67b55872ed0f6a7ad8ad2526a9faf03a"

  bottle do
    cellar :any
    sha1 "94773d87f8879d53bdcaa26853342d7a45af1da8" => :yosemite
    sha1 "88197b7fa15f6842a2fe3e07f38e825e7b02947e" => :mavericks
    sha1 "c2b5c09aae9987d2441ca205d74ce44439e912c0" => :mountain_lion
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
