require 'formula'


class Mal4s < Formula

  version '1.0.0'

  homepage 'https://github.com/secure411dotorg/mal4s/'
  url 'https://service.dissectcyber.com/mal4s/mal4s-1.0.0.tar.gz'
  sha1 '4f1d9bcd3162c5b3a056f8a25382a7fa7cca0909'

  head do
    url 'https://github.com/secure411dotorg/mal4s.git'
  end

  depends_on :automake
  depends_on :libtool

  depends_on :x11 if MacOS::X11.installed?
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
    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"
    system "autoreconf -f -i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make install"
  end
  test do
    system "false"
  end
end
