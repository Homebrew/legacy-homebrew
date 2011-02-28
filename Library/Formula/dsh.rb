require 'formula'

class Dsh <Formula
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.9.tar.gz'
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  md5 '60734780242172fca9e68d223654292d'

  depends_on 'libdshconfig'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
