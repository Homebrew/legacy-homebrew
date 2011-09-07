require 'formula'

class Libiconv < Formula
  url 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  md5 '7ab33ebd26687c744a37264a330bbe9a'
  homepage 'http://www.gnu.org/software/libiconv/'
end

class Tin < Formula
  url 'ftp://ftp.tin.org/pub/news/clients/tin/unstable/tin-1.9.5.tar.gz'
  homepage 'http://www.tin.org'
  md5 '51661ec8ae10aa7ccf97cbf309cbbf11'

  def install
    iconvd = Pathname.getwd+'iconv'
    iconvd.mkpath

    Libiconv.new.brew do
      system "./configure", "--prefix=#{iconvd}", "--disable-debug", "--disable-dependency-tracking",
                            "--enable-static", "--disable-shared"
      system "make install"
    end
    ENV.enable_warnings
    ENV['LDFLAGS'] = " #{iconvd}/lib/libiconv.a"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make build"
    system "make install"
  end
end
