class ImapUw < Formula
  # imap-uw is unmaintained software; the author has passed away and there is
  # no active successor project.
  desc "University of Washington IMAP toolkit"
  homepage "https://www.washington.edu/imap/"
  url "ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz"
  mirror "http://ftp.ntua.gr/pub/net/mail/imap/imap-2007f.tar.gz"
  sha256 "53e15a2b5c1bc80161d42e9f69792a3fa18332b7b771910131004eb520004a28"

  bottle do
    cellar :any
    sha256 "0675f08cd452452aa16ad7c4a779734af0959e16caced6fb44cc792b274acced" => :el_capitan
    sha1 "74c958abb4628c752632abf47cfc7b96ab034e8b" => :yosemite
    sha1 "8e635bb16b3053ff8bef24fc8261c572fa48ea91" => :mavericks
    sha1 "a68b0990595cefe59e74b8aab30928ab37cbf6f4" => :mountain_lion
  end

  depends_on "openssl"

  def install
    ENV.j1
    inreplace "Makefile" do |s|
      s.gsub! "SSLINCLUDE=/usr/include/openssl",
              "SSLINCLUDE=#{Formula["openssl"].opt_include}/openssl"
      s.gsub! "SSLLIB=/usr/lib",
              "SSLLIB=#{Formula["openssl"].opt_lib}"
      s.gsub! "-DMAC_OSX_KLUDGE=1", "" if MacOS.version >= :snow_leopard
    end
    inreplace "src/osdep/unix/ssl_unix.c", "#include <x509v3.h>\n#include <ssl.h>",
                                           "#include <ssl.h>\n#include <x509v3.h>"
    system "make", "oxp"

    # email servers:
    sbin.install "imapd/imapd", "ipopd/ipop2d", "ipopd/ipop3d"

    # mail utilities:
    bin.install "dmail/dmail", "mailutil/mailutil", "tmail/tmail"

    # c-client library:
    #   Note: Installing the headers from the root c-client directory is not
    #   possible because they are symlinks and homebrew dutifully copies them
    #   as such. Pulling from within the src dir achieves the desired result.
    doc.install Dir["docs/*"]
    lib.install "c-client/c-client.a" => "libc-client.a"
    (include + "imap").install "c-client/osdep.h", "c-client/linkage.h"
    (include + "imap").install Dir["src/c-client/*.h", "src/osdep/unix/*.h"]
  end
end
