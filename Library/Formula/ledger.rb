require 'formula'

class Ledger < Formula
  url 'ftp://ftp.newartisans.com/pub/ledger/ledger-2.6.2.tar.gz'
  md5 'b2e6fa98e7339d1e130b1ea9af211c0f'
  homepage 'http://www.newartisans.com/software/ledger.html'
  head 'git://github.com/jwiegley/ledger.git', :branch => 'next'

  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'pcre'
  depends_on 'expat'

  def install
    unless 'HEAD' == @version
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    else
      # gmp installs x86_64 only
      inreplace 'acprep', "'-arch', 'i386', ", "" if Hardware.is_64_bit?
      system "./acprep -j#{Hardware.processor_count} opt make -- --prefix=#{prefix}"
    end
    system "make install"
  end
end
