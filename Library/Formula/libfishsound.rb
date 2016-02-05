class Libfishsound < Formula
  desc "Decode and encode audio data using the Xiph.org codecs"
  homepage "https://xiph.org/fishsound/"
  url "http://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz"
  sha256 "2e0b57ce2fecc9375eef72938ed08ac8c8f6c5238e1cae24458f0b0e8dade7c7"

  bottle do
    cellar :any
    revision 1
    sha256 "4fcfc4270d73ac2b0e8d8a4d1fe6b94a1093502b802ed327febb5286ad5140b9" => :yosemite
    sha256 "b8c54b7d3b2bc5e433b20f89f67c6cb3d03b18e0881126a526ae1ff028d8c220" => :mavericks
    sha256 "f839c0de6981edbc6a522fe300693746d2e2744fa430a8dd4cf1c09f0e4268b5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "speex" => :optional
  depends_on "flac" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
