require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'https://github.com/acaudwell/Gource/releases/download/gource-0.41/gource-0.41.tar.gz'
  sha1 '75aa1e2c5afc2f91b54629d086f2a80bf3b553e5'

  head do
    url 'https://github.com/acaudwell/Gource.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on :x11 => :optional
  depends_on :freetype

  depends_on 'pkg-config' => :build
  depends_on 'glm' => :build

  if MacOS.version < :mavericks
    depends_on 'boost' => 'c++11'
  else
    depends_on 'boost'
  end

  depends_on 'glew'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on 'sdl2'
  depends_on 'sdl2_image'

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    system "autoreconf -f -i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make install"
  end
end
