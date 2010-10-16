require 'formula'

class Nano <Formula
  url 'http://www.nano-editor.org/dist/v2.2/nano-2.2.5.tar.gz'
  homepage 'http://www.nano-editor.org/'
  md5 '77a10a49589f975ce98350a4527a2ebf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--disable-nls"
    system "make install"
  end
end
