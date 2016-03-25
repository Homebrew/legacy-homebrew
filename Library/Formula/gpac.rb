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
  revision 1
  head "https://github.com/gpac/gpac.git"

  bottle do
    sha256 "d711ffb2ba85dc62a67dbedf5bd1abb3c9cbc4bf55fabb968130fbf5f4fb4ccb" => :el_capitan
    sha256 "0be1701105c9c72b08fc3aad37792c43a53c9e4287cd53a88944ae55b15baaf2" => :yosemite
    sha256 "97bda5a3f31d4341eb14c0f0bc7b5c54ddda5f086507e986ab4e29c7f8f5abff" => :mavericks
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
