class Mal4s < Formula
  desc "Malicious host finder based on gource"
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz"
  sha256 "1c40ca9d11d113278c4fbd5c7ec9ce0edc78d6c8bd1aa7d85fb6b9473e60f0f1"
  revision 3

  head "https://github.com/secure411dotorg/mal4s.git"

  bottle do
    sha256 "37f754203e54336c818516e05fe48b35ab5c92a2c84ec76fb7797c97655cd771" => :el_capitan
    sha256 "a67d3ee134bc093d3539c40176cd5b6c6d2e1feda5f9674afb031fa92db3daca" => :yosemite
    sha256 "92fa79d790ae03b9d9e9ca2946a4c9c2a1c9a42571eba6484d1c07f531829695" => :mavericks
  end

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
    args << "--without-x" if build.without? "x11"
    system "autoreconf", "-f", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mal4s", "--stop-at-end", "#{share}/mal4s/sample--newns.mal4s"
  end
end
