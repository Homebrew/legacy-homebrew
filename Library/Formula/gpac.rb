# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  url "https://github.com/gpac/gpac/archive/v0.6.0.tar.gz"
  sha256 "b50a772ff55b5fa3680f50a06127262f43dcedf75143788101880e6f2c4e25b8"
  head "https://github.com/gpac/gpac.git"

  bottle do
    sha256 "3feeb23cfe274e9e8e42cc1589ccd45a4b9c9006444bfce9205454c242abe205" => :yosemite
    sha256 "495e9d51129841da9b135a8112c34ab831f01dfffb5f18db44e59b83813f16c0" => :mavericks
    sha256 "b6291bcf89fc7ea7232e060ddebc3b5c561009a0923ad54b40ab991875c2fa57" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "a52dec" => :optional
  depends_on "jpeg" => :optional
  depends_on "faad2" => :optional
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mad" => :optional
  depends_on "sdl" => :optional
  depends_on "theora" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "openjpeg" => :optional

  def install
    args = ["--disable-wx",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]
    args << "--disable-x11" if build.without? "x11"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/MP4Box", "-add", test_fixtures("test.mp3"), "#{testpath}/out.mp4"
    File.exist? "#{testpath}/out.mp4"
  end
end
