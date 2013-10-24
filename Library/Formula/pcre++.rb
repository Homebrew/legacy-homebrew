require 'formula'

class Pcrexx < Formula
  homepage 'http://www.daemon.de/PCRE'
  url 'http://www.daemon.de/idisk/Apps/pcre++/pcre++-0.9.5.tar.gz'
  sha1 '7cb640555c6adf34bf366139b22f6d1a66bd1fb0'

  depends_on 'pcre'

  def install
    pcre = Formula.factory('pcre').opt_prefix
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-pcre-dir-lib=#{pcre}"
    system "make install"

    # Pcre++ ships Pcre.3, which causes a conflict with pcre.3 from pcre
    # in case-insensitive file system. Rename it to pcre++.3 to avoid
    # this problem.
    mv man3/'Pcre.3', man3/'pcre++.3'
  end

  def caveats; <<-EOS.undent
    The man page has been renamed to pcre++.3 to avoid conflicts with
    pcre in case-insensitive file system.  Please use "man pcre++"
    instead.
    EOS
  end
end
