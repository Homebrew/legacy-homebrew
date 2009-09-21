require 'brewkit'

class Lftp <Formula
  @url='http://ftp.yars.free.net/pub/source/lftp/lftp-3.7.15.tar.gz'
  @homepage='http://lftp.yar.ru/'
  @md5='6c43ffdb59234ff0533cfdda0c3c305c'

  depends_on 'readline'

  def install
    ENV['CXXFLAGS'] += " -fno-exceptions -fno-rtti -fno-implement-inlines"
    ENV['LDFLAGS'] += " -Xlinker -search_paths_first -L/usr/local/lib"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--with-openssl", "--disable-shared", "--disable-nls"
    system "make install"
  end
end
