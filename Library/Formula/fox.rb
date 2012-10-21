require 'formula'

class Fox < Formula
  homepage 'http://www.fox-toolkit.org/'
  url 'ftp://ftp.fox-toolkit.org/pub/fox-1.6.46.tar.gz'
  sha1 '0d77f6b1d6cb6e57590f2825e336d963c0218061'

  # Development and stable branches are incompatible
  devel do
    url 'ftp://ftp.fox-toolkit.org/pub/fox-1.7.36.tar.gz'
    sha1 '56095e26bfb01fbeb7975e6ca5082acf1f982873'
  end

  depends_on :x11

  def install
    # Yep, won't find freetype unless this is all set.
    ENV.append "CFLAGS", "-I#{MacOS::X11.include}/freetype2"
    ENV.append "CPPFLAGS", "-I#{MacOS::X11.include}/freetype2"
    ENV.append "CXXFLAGS", "-I#{MacOS::X11.include}/freetype2"

    system "./configure", "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x", "--with-opengl"
    system "make install"
  end
end
