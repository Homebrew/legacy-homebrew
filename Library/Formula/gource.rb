require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'https://github.com/acaudwell/Gource.git', :tag => "gource-0.37"
  version "0.37"
  head 'https://github.com/acaudwell/Gource.git'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on 'glew'

  if MacOS.xcode_version >= "4.3"
    # download a tarball with configure and remove the need for these!
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.x11 # Put freetype-config in path

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    system "autoreconf -f -i"

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
