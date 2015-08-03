class Libdshconfig < Formula
  desc "Distributed shell library"
  homepage "http://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz"
  sha256 "6f372686c5d8d721820995d2b60d2fda33fdb17cdddee9fce34795e7e98c5384"

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
    system "make", "install"
  end
end
