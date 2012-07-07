require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'http://gource.googlecode.com/files/gource-0.38.tar.gz'
  sha1 '78f8c2064114313851f53b657d12db28abb89fae'

  head 'https://github.com/acaudwell/Gource.git'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on :x11 # for Freetype

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

    system "autoreconf -f -i" if ARGV.build_head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-freetypetest"
    system "make install"
  end

  def test
    cd HOMEBREW_REPOSITORY do
      system "#{bin}/gource"
    end
  end
end
