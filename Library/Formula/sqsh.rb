require 'formula'

class Sqsh < Formula
  homepage 'http://www.sqsh.org/'
  url 'http://downloads.sourceforge.net/project/sqsh/sqsh/sqsh-2.3/sqsh-2.3.tgz'
  sha1 '225bd6cfa5dcad4fae419becc5217fb3465c66d1'

  option "enable-x", "Enable X windows support"

  depends_on :x11 if build.include? "enable-x"
  depends_on 'freetds'
  depends_on 'readline'

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-readline
    ]

    ENV['LIBDIRS'] = Readline.new('readline').lib
    ENV['INCDIRS'] = Readline.new('readline').include

    if build.include? "enable-x"
      args << "--with-x"
      args << "--x-libraries=#{MacOS::X11.lib}"
      args << "--x-includes=#{MacOS::X11.include}"
    end

    ENV['SYBASE'] = Freetds.new("freetds").prefix
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end
end
