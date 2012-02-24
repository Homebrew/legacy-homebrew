require 'formula'

class Ledger < Formula
  url 'ftp://ftp.newartisans.com/pub/ledger/ledger-2.6.3.tar.gz'
  md5 '6d5d8396b1cdde5f605854c7d21d1460'
  homepage 'http://ledger-cli.org'
  head 'https://github.com/jwiegley/ledger.git', :branch => 'next'

  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'pcre'
  depends_on 'expat'

  def options
    [['--no-python', 'Disable Python support']]
  end

  def install
    unless 'HEAD' == @version
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    else
      # gmp installs x86_64 only
      inreplace 'acprep', "'-arch', 'i386', ", "" if Hardware.is_64_bit?
      no_python = ((ARGV.include? '--no-python') ? '--no-python' : '')
      system "./acprep #{no_python} -j#{ENV.make_jobs} opt make -- --prefix=#{prefix}"
    end
    system 'make'
    ENV.deparallelize
    system 'make install'
  end
end
