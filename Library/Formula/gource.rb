require 'formula'

class Gource <Formula
  homepage 'http://code.google.com/p/gource/'
  # Stable version doesn't work on 10.6.3
  # url 'http://gource.googlecode.com/files/gource-0.26.tar.gz'
  # sha1 'f2e92a5f806264790f61a988d58dd488d1dc169a'
  head 'git://github.com/acaudwell/Gource.git'

  depends_on 'pkg-config'
  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'ftgl'
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'pcre'

  def install
    # Put freetype-config in path
    ENV.prepend 'PATH', "/usr/X11/bin", ":"

    system "autoreconf -f -i" unless File.exist? "configure"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-freetypetest"
    system "make install"
  end
end
