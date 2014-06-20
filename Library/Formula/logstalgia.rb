require 'formula'

class Logstalgia < Formula
  homepage 'http://code.google.com/p/logstalgia/'
  url 'https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.5/logstalgia-1.0.5.tar.gz'
  sha1 '3687d67033ef4fa0abebda66fd77c56f7f05bcc7'
  revision 1

  head do
    url 'https://github.com/acaudwell/Logstalgia.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'sdl2'
  depends_on 'sdl2_image'
  depends_on 'freetype'
  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build
  depends_on 'glm' => :build
  depends_on 'glew'
  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'pcre'

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf -f -i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make"
    system "make install"
  end
end
