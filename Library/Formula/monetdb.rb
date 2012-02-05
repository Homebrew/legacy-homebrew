require 'formula'

class Monetdb < Formula
  url 'http://dev.monetdb.org/downloads/sources/Aug2011-SP1/MonetDB-11.5.3.tar.bz2'
  sha1 '6ca7358a5ecab56396a5f9b6d795d90cd5635f17'
  homepage 'http://www.monetdb.org/'

  head 'http://dev.monetdb.org/hg/MonetDB', :using => :hg

  depends_on 'pcre'

  # The compilation of MonetDB fails with the libedit library provided by OSX.
  # However, having a keg-only installation of libreadline is just fine.
  depends_on 'readline'

  def install
    # If we are compiling from HEAD, we need to run bootstrap first.
    if ARGV.build_head?
      system "./bootstrap"
    end

    system "./configure", "--prefix=#{prefix}", "--enable-debug=no", "--enable-assert=no",
                          "--enable-optimize=yes", "--enable-testing=no"
    system "make install"
  end
end
