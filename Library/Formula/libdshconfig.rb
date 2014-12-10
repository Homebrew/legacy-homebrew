require 'formula'

class Libdshconfig < Formula
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz'
  sha1 'fc19f56ee61ff71ae5699bc97b89cc4931ce64a1'

  bottle do
    cellar :any
    revision 1
    sha1 "73fdb9ac0dd0f709de92b0466cdff165cafdc4ca" => :yosemite
    sha1 "a59b54a8367fe170fecfe06ebacf32977226b014" => :mavericks
    sha1 "6af39f2bf12442a3d187cf8ed0e0fddd983a6d3f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
