require 'formula'

class Mal4s < Formula
  homepage 'https://github.com/secure411dotorg/mal4s/'
  url 'https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz'
  sha1 'd1f38c0e09b1f5963e70c93c88ea41a3d7890887'

  head 'https://github.com/secure411dotorg/mal4s.git'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "jpeg"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "freetype"
  depends_on :x11 => :optional

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-x" if build.without? 'x11'
    system "autoreconf", "-f", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mal4s", "--stop-at-end", "#{share}/mal4s/sample--newns.mal4s"
  end
end
