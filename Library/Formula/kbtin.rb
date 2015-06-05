class Kbtin < Formula
  homepage "http://kbtin.sourceforge.net"
  url "https://downloads.sourceforge.net/project/kbtin/kbtin/1.0.15/kbtin-1.0.15.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/k/kbtin/kbtin_1.0.15.orig.tar.xz"
  sha256 "57231dfd5dc0edcf71dcdafc16dc2e836c5d96e3b28927997bd2cc5061a313fa"

  depends_on "gnutls"

  if MacOS.version >= :mavericks
    # https://sourceforge.net/p/kbtin/bugs/11/
    fails_with :clang do
      cause "error: conflicting types for '__builtin___strlcpy_chk'"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "background-color: black;",
                 `echo homebrew | #{bin}/ansi2html`
  end
end
