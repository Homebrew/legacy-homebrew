require 'formula'

class Bitchx < Formula
  homepage 'http://wiki.bitchx.org/'
  version 'r152'
  url 'http://bitchx.svn.sourceforge.net/svnroot/bitchx/trunk', :use => :svn, :revision => 152
  head 'http://bitchx.svn.sourceforge.net/svnroot/bitchx/trunk', :use => :svn

  def options
    [
      ['--with-ssl', "Compile with SSL support."],
    ]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--disable-glibtest",
            "--disable-gtktest",
            "--disable-imlibtest",
            "--disable-gnometest",
            "--disable-esdtest",
            "--disable-audiofiletest"
    ]

    if ARGV.include? '--with-ssl'
      args << "--with-ssl"
    end

    system "./configure", *args
    system "make install"
  end

  def caveats
    s = " "
    if !ARGV.include? '--with-ssl'
      s+= <<-EOS.undent
        The default install does not include support for ssl. If you wish to
         include support for SSL please install with the following option.

         --with-ssl

      EOS

      return s
    end
  end

end
