class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://logcheck.alioth.debian.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.17.tar.xz"
  sha256 "c2d3fc323e8c6555e91d956385dbfd0f67b55872ed0f6a7ad8ad2526a9faf03a"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "aab0ab066fe378c88c74b9783a90fb0a4896dd3a6258d00b08cd1d0d2987b108" => :el_capitan
    sha256 "c75e01fb14bdd0adfc04e110a3c8a65d036b9bd71ac03a6ac58d69006a892fe9" => :yosemite
    sha256 "25f2dfec7bb30fded535bdb354767a2680108dcd93d0627f8384a115c008cf89" => :mavericks
  end

  def install
    inreplace "Makefile", "$(DESTDIR)/$(CONFDIR)", "$(CONFDIR)"
    # email sent to logcheck mailing list asking whether this patch can land upstream:
    # http://lists.alioth.debian.org/pipermail/logcheck-users/2015-December/000328.html
    inreplace "src/logcheck-test", "mktemp --tmpdir logcheck-test", "mktemp /tmp/logcheck-test"

    system "make", "install", "--always-make", "DESTDIR=#{prefix}",
                   "SBINDIR=sbin", "BINDIR=bin", "CONFDIR=#{etc}/logcheck"
  end

  test do
    cp HOMEBREW_REPOSITORY/"README.md", testpath
    system "#{sbin}/logtail", "-f", "README.md"
  end
end
