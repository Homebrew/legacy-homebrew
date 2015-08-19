class Libfishsound < Formula
  desc "Decode and encode audio data using the Xiph.org codecs"
  homepage "https://xiph.org/fishsound/"
  url "http://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz"
  sha256 "2e0b57ce2fecc9375eef72938ed08ac8c8f6c5238e1cae24458f0b0e8dade7c7"

  bottle do
    cellar :any
    revision 1
    sha1 "d298837ad460c86599b65b8bdf4ca62a24ac8549" => :yosemite
    sha1 "857f580172e6c109e962179db28085190c7dead1" => :mavericks
    sha1 "1099a2dee3da3ef7748b0e752394e2a4de26d6af" => :mountain_lion
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
