require 'formula'

class Fox < Formula
  homepage 'http://www.fox-toolkit.org/'
  url 'ftp://ftp.fox-toolkit.org/pub/fox-1.6.44.tar.gz'
  md5 '5d3658faf0855826ff6ce8f95e413949'

  # Development and stable branches are incompatible
  devel do
    url 'http://ftp.fox-toolkit.org/pub/fox-1.7.32.tar.gz'
    md5 '1cf2607d15ffad5b664cf65bfcd249bc'
  end

  depends_on :x11

  fails_with :llvm do
    cause "Inline asm errors during build"
  end if ARGV.build_devel?

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
