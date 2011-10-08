require 'formula'

class Libiconv < Formula
  url 'http://ftpmirror.gnu.org/libiconv/libiconv-1.13.1.tar.gz'
  md5 '7ab33ebd26687c744a37264a330bbe9a'
  homepage 'http://www.gnu.org/software/libiconv/'
end

class Tin < Formula
  url 'ftp://ftp.tin.org/pub/news/clients/tin/stable/tin-2.0.0.tar.gz'
  homepage 'http://www.tin.org'
  md5 'fae76336a6bfe82aaa9e99f2212a356c'

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
