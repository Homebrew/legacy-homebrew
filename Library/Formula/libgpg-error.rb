require 'formula'

class LibgpgError < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.10.tar.bz2'
  sha1 '95b324359627fbcb762487ab6091afbe59823b29'

  def install
    ENV.universal_binary  # build fat so wine can use it
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
