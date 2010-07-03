require 'formula'

class Utf8cpp <Formula
  url 'http://sourceforge.net/projects/utfcpp/files/utf8cpp_2x/Release%202.2.4/utf8_v2_2_4.zip/download'
  homepage 'http://utfcpp.sourceforge.net/'
  md5 'b30e1f7087aeca5ad38f7966aaf5f739'
  # Use version 2.2.4 even for ledger HEAD install
  version '2.2.4'
  #head 'http://github.com/jwiegley/utfcpp/'
end

class Ledger <Formula
  url 'ftp://ftp.newartisans.com/pub/ledger/ledger-2.6.2.tar.gz'
  md5 'b2e6fa98e7339d1e130b1ea9af211c0f'
  homepage 'http://www.newartisans.com/software/ledger.html'
  head 'git://github.com/jwiegley/ledger.git', :branch => 'master'

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
      utfcpp = Pathname.new(Dir.pwd)+'lib/utfcpp'
      Utf8cpp.new.brew { utfcpp.install Dir['*'] }
      # gmp installs x86_64 only
      inreplace 'acprep', "'-arch', 'i386', ", "" if Hardware.is_64_bit?
      system "./acprep -j#{Hardware.processor_count} opt make -- --prefix=#{prefix}"
    end
    system "make install"
  end
end
