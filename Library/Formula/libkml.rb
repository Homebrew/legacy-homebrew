require 'formula'

class Libkml < Formula
  homepage 'http://code.google.com/p/libkml/'
  url 'http://libkml.googlecode.com/files/libkml-1.2.0.tar.gz'
  sha1 '3fa5acdc2b2185d7f0316d205002b7162f079894'

  head 'http://libkml.googlecode.com/svn/trunk/', :using => :svn

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install

    if build.head?
      # The inreplace line below is only required until the patch in #issue 186
      # is applied. http://code.google.com/p/libkml/issues/detail?id=186
      # If the patch is applied, this find and replace will be unnecessary, but also
      # harmless
      inreplace 'configure.ac', '-Werror', ''

      # Compatibility with Automake 1.13 and newer.
      inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADER'

      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
