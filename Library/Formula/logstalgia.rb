require 'formula'

class Logstalgia <Formula
  url 'http://logstalgia.googlecode.com/files/logstalgia-1.0.3.tar.gz'
  head 'git://github.com/acaudwell/Logstalgia.git'
  homepage 'http://code.google.com/p/logstalgia/'
  md5 '5160380adb1fb1ed9272cf57fbdf3341'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'ftgl'
  depends_on 'jpeg'
  depends_on 'pcre'

  def install
    ENV.x11 # Put freetype-config in path

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf -f -i" unless File.exist? "configure"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
