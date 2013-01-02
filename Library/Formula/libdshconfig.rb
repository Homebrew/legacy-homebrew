require 'formula'

class Libdshconfig < Formula
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz'
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  sha1 'fc19f56ee61ff71ae5699bc97b89cc4931ce64a1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
