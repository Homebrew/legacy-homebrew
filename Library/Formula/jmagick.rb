require 'formula'

class Jmagick < Formula
  homepage 'http://www.jmagick.org'
  url 'http://downloads.jmagick.org/6.4.0/jmagick-6.4.0-src.tar.gz'
  sha1 'c9e08ae4eb91166a14c56f4bc357727add085799'

  head 'https://jmagick.svn.sourceforge.net/svnroot/jmagick', :using => :svn

  depends_on "imagemagick"

  fails_with :clang do
    build 421
    cause "magick_MagickImage.c:4424:10: error: non-void function 'Java_magick_MagickImage_resetImagePage' should return a value [-Wreturn-type]"
  end

  def install
    java_home = `/usr/libexec/java_home`
    ENV['JAVA_HOME'] = java_home
    ENV.append_to_cflags '-I#{java_home}/include/darwin'
    cd('trunk') do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end

    ln lib/'libJMagick-6.6.9.so', lib/'libJMagick.dylib'
  end

  def caveats; <<-EOS.undent
    To install the jmagick jar into your local Maven repo:

      cd $(brew --prefix jmagick)/lib
      mvn install:install-file -Dfile=jmagick-6.6.9.jar -DgroupId=jmagick -DartifactId=jmagick -Dpackaging=jar -Dversion=6.6.9

    EOS
  end
end
