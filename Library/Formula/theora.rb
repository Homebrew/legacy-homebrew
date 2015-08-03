class Theora < Formula
  desc "Open video compression format"
  homepage "http://www.theora.org/"
  url "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

  bottle do
    cellar :any
    revision 1
    sha1 "af6b483eb5119d88559d435f457b6d12d5ecf5bc" => :yosemite
    sha1 "1ef8982b17448df7e7a665ff74381a6013a430a9" => :mavericks
    sha1 "55f7781fe5ae59ef1c0aa1dfe95fd4d4f37ce060" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-oggtest",
                          "--disable-vorbistest",
                          "--disable-examples"
    system "make", "install"
  end
end
