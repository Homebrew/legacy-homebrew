require 'formula'

class Libdshconfig < Formula
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz'
  sha1 'fc19f56ee61ff71ae5699bc97b89cc4931ce64a1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
