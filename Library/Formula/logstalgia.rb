require 'formula'

class Logstalgia < Formula
  homepage 'http://code.google.com/p/logstalgia/'
  url 'http://logstalgia.googlecode.com/files/logstalgia-1.0.3.tar.gz'
  md5 '5160380adb1fb1ed9272cf57fbdf3341'

  head 'https://github.com/acaudwell/Logstalgia.git'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'ftgl'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on :x11

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf -f -i" if ARGV.build_head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
