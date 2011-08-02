require 'formula'

class SwiProlog < Formula
  url 'http://www.swi-prolog.org/download/stable/src/pl-5.10.2.tar.gz'
  head 'git://www.swi-prolog.org/home/pl/git/pl.git'
  homepage 'http://www.swi-prolog.org/'
  md5 '7973bcfd3854ae0cb647cc62f2faabcf'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gmp'
  depends_on 'jpeg'
  depends_on 'mcrypt'
  depends_on 'gawk'

  # 10.5 versions of these are too old
  if MacOS.leopard?
    depends_on 'fontconfig'
    depends_on 'expat'
  end

  fails_with_llvm "Exported procedure chr_translate:chr_translate_line_info/3 is not defined"

  def options
    [['--lite', "Don't install any packages; overrides --with-jpl"],
     ['--without-jpl', "Include JPL, the Java-Prolog Bridge"]]
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    ENV.append 'DISABLE_PKGS', "jpl" if ARGV.include? "--without-jpl"

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

    # './prepare' prompts the user to build documentation
    # (which requires other modules). '3' is the option
    # to ignore documentation.
    system "echo '3' | ./prepare" if ARGV.build_head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    By default, this formula installs the JPL bridge.
    On 10.6, this requires the "Java Developer Update" from Apple:
     * https://github.com/mxcl/homebrew/wiki/new-issue

    Use the "--without-jpl" switch to skip installing this component.
    EOS
  end
end
