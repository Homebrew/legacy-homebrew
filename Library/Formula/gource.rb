require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'http://gource.googlecode.com/files/gource-0.39.tar.gz'
  sha1 '1dd6476e56a197354ce93612c7be9aff8c1f8cd2'

  head 'https://github.com/acaudwell/Gource.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

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
