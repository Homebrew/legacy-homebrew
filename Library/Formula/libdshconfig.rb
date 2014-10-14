require 'formula'

class Libdshconfig < Formula
  homepage 'http://www.netfort.gr.jp/~dancer/software/dsh.html.en'
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz'
  sha1 'fc19f56ee61ff71ae5699bc97b89cc4931ce64a1'

  bottle do
    cellar :any
    sha1 "d03023011d625c5c9674c79f79532b70624f530f" => :mavericks
    sha1 "403dd7f3c77a1d3691b973a7a90c37cf00935aa6" => :mountain_lion
    sha1 "6a0219f233de4c9808069cc3199d201df2e33e02" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
