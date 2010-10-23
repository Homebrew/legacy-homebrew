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
  depends_on 'mcrypt'
  depends_on 'gawk'

  def options
    [['--lite', "Don't install any packages; overrides --with-jpl"],
     ['--with-jpl', "Include JPL, the Java-Prolog Bridge"]]
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]

    # It looks like Apple has borked the Java JNI headers in Java 1.6.0_22-b04-37.
    # Will not install the JPL bridge by default, which depends on them.
    unless ARGV.include? "--with-jpl"
      ohai <<-EOS.undent
        JPL, the Java-Prolog bridge, is not installed by this formula by default.
        If you want to indclude the Java-Prolog bridge, add the --with-jpl option.
      EOS

      ENV.append 'DISABLE_PKGS', "jpl"
    end

    if x11_installed?
      # SWI-Prolog requires X11 for XPCE
      ENV.x11
    else
      opoo  "It appears that X11 is not installed. The XPCE packages will not be built."
      ENV.append 'DISABLE_PKGS', "xpce"
    end

    # SWI-Prolog's Makefiles don't add CPPFLAGS to the compile command, but do
    # include CIFLAGS. Setting it here. Also, they clobber CFLAGS, so including
    # the Homebrew-generated CFLAGS into COFLAGS here.
    ENV['CIFLAGS'] = ENV['CPPFLAGS']
    ENV['COFLAGS'] = ENV['CFLAGS']

    # Build the packages unless --lite option specified
    args << "--with-world" unless ARGV.include? "--lite"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
