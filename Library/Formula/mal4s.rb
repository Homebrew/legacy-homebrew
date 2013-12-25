require 'formula'

class Mal4s < Formula

  homepage 'https://github.com/secure411dotorg/mal4s/'
  url 'https://service.dissectcyber.com/mal4s/mal4s-1.1.0.tar.gz'
  sha1 '6431784384b11deaf4448b7f94bbb6eb4877a66e'

  head 'https://github.com/secure411dotorg/mal4s.git'

  depends_on :automake
  depends_on :libtool
  depends_on :x11 => :optional
  depends_on :freetype
  depends_on 'pkg-config' => :build
  depends_on 'glm' => :build
  depends_on 'boost'
  depends_on 'glew'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on 'sdl2'
  depends_on 'sdl2_image'
  depends_on 'sdl2_mixer'

  def install
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    system "autoreconf -f -i"
    if MacOS::X11.installed?
        system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    else
        system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    end
    system "make install"
  end
end
