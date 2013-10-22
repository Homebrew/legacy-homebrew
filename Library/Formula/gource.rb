require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'http://gource.googlecode.com/files/gource-0.40.tar.gz'
  sha1 '7af594f84c0ec4c84278a8e9008f83a7a02e97fa'

  head do
    url 'https://github.com/acaudwell/Gource.git'

    depends_on :automake
    depends_on :libtool
  end

  depends_on :x11 if MacOS::X11.installed?
  depends_on :freetype

  depends_on 'pkg-config' => :build
  depends_on 'glm' => :build

  depends_on 'boost'
  depends_on 'glew'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on 'sdl'
  depends_on 'sdl_image'

  def install
    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    system "autoreconf -f -i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make install"
  end
end
