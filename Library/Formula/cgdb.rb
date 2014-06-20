require 'formula'

class Cgdb < Formula
  homepage 'http://cgdb.github.io/'
  url 'http://cgdb.me/files/cgdb-0.6.7.tar.gz'
  sha1 '5e29e306502888dd660a9dd55418e5c190ac75bb'

  depends_on 'readline'

  # man page for cgdb is only there to point people to the info page where all
  # of the actual documentation is, so skip cleaning the info to preserve the
  # documentation
  skip_clean 'share/info'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula['readline'].opt_prefix}"
    system "make install"
  end
end
