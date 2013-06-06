require 'formula'

class Sqsh < Formula
  homepage 'http://www.sqsh.org/'
  url 'http://sourceforge.net/projects/sqsh/files/sqsh/sqsh-2.2.0/sqsh-2.2.0.tgz'
  sha1 'f3c2276fe53c05ddf51173fd109c5111c90879c6'

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
