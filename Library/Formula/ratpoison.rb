require 'formula'

class Ratpoison < Formula
  url 'http://download.savannah.nongnu.org/releases/ratpoison/ratpoison-1.4.5.tar.gz'
  homepage 'http://www.nongnu.org/ratpoison/'
  md5 '330a08dbed6be88cab54f6947e9f0b60'
  #head "git://git.savannah.nongnu.org/ratpoison.git"

  def install
    # Make sure that configure sets the HAVE_GETLINE constant
    # Bug reported fixed in HEAD.
    # See http://lists.nongnu.org/archive/html/ratpoison-devel/2009-07/msg00008.html
    inreplace 'configure.in',
    'AC_CHECK_FUNCS(getopt getopt_long setsid setpgid setpgrp putenv vsnprintf usleep)',
    'AC_CHECK_FUNCS(getopt getopt_long setsid setpgid setpgrp putenv vsnprintf usleep getline)'

    # regenerate the configure script
    system "autoconf"
    system "autoheader"

    # configure pointing gcc to the X11 libraries and includes
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--x-include=/usr/X11/include",
                          "--x-libraries=/usr/X11/lib"

    system "make install"
  end
  def caveats
    <<-EOS
    To launch ratpoison upon starting X11 / XQuartz, you must set
    the USERWM environment variable to "ratpoison".
    EOS
  end
end
