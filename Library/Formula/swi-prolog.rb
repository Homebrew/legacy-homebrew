require 'formula'

class SwiProlog <Formula
  url 'http://www.swi-prolog.org/download/stable/src/pl-5.10.1.tar.gz'
  homepage 'http://www.swi-prolog.org/'
  md5 '9168a2c872d2130467c3e74b80ed3ee0'

  depends_on 'pkg-config'
  depends_on 'readline'
  depends_on 'gmp'
  depends_on 'jpeg'
  depends_on 'fontconfig' if MACOS_VERSION < 10.6
  depends_on 'ncursesw'
  depends_on 'mcrypt'
  depends_on 'gawk'

  def options
    [['--lite', "Don't install any packages"]]
  end

  def install
    ENV['CIFLAGS'] = ENV['CPPFLAGS']
    if ARGV.include? '--lite'
      world = ''
    else
      world = '--with-world'
    end

    system "./configure", "--prefix=#{prefix}", world, "--x-includes=/usr/X11/include",
                          "--x-libraries=/usr/X11/lib", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
