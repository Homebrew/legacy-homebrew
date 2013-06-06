require 'formula'

class Dsh < Formula
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.9.tar.gz'
  sha1 'd5d7828a06d079182315492d6f7a5a3dce47a5de'

  depends_on 'libdshconfig'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
