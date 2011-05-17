require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'git://github.com/acaudwell/Gource.git', :tag => "7730617ba28b9e6d72e9"
  version "0.34"
  head 'git://github.com/acaudwell/Gource.git'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'ftgl'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on 'glew'

  def install
    ENV.x11 # Put freetype-config in path

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    system "autoreconf -f -i" unless File.exist? "configure"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-freetypetest"
    system "make install"
  end

  def test
    Dir.chdir HOMEBREW_REPOSITORY do
      system "gource"
    end
  end
end
