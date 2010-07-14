require 'formula'

class Tarsnap <Formula
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.27.tgz'
  homepage 'http://www.tarsnap.com/'
  sha256 'e26dc7c2aa64c17d8063bc61462d1a0f546b56e33b41fbd2fd6925e506c6914f'

 depends_on 'lzma' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-sse2"
    system "make install"
  end
end
