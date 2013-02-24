require 'formula'

class SwiProlog < Formula
  homepage 'http://www.swi-prolog.org/'
  url 'http://www.swi-prolog.org/download/stable/src/pl-6.2.6.tar.gz'
  sha256 '9412f0753a61c30dbcf1afac01fe7c9168002854709e00e09c21f959e1232146'

  head 'git://www.swi-prolog.org/home/pl/git/pl.git'

  option 'lite', "Disable all packages"
  option 'with-jpl', "Enable JPL (Java Prolog Bridge)"
  option 'with-xpce', "Enable XPCE (Prolog Native GUI Library)"

  depends_on 'readline'
  depends_on 'gmp'
<<<<<<< HEAD
  depends_on 'jpeg'
  depends_on 'mcrypt'
  depends_on 'gawk'
<<<<<<< HEAD
  depends_on :x11 if MacOS::XQuartz.installed?
=======
  depends_on :x11 if MacOS::X11.installed?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======

  if build.include? 'with-xpce'
    depends_on 'pkg-config' => :build
    depends_on :x11
    depends_on 'jpeg'
  end
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  # 10.5 versions of these are too old
  if MacOS.version == :leopard
    depends_on 'fontconfig'
    depends_on 'expat'
  end

  fails_with :llvm do
    build 2335
    cause "Exported procedure chr_translate:chr_translate_line_info/3 is not defined"
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
<<<<<<< HEAD
    ENV.append 'DISABLE_PKGS', "jpl" if build.include? "without-jpl"

<<<<<<< HEAD
    unless MacOS::XQuartz.installed?
=======
    unless MacOS::X11.installed?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
      # SWI-Prolog requires X11 for XPCE
      opoo "It appears that X11 is not installed. The XPCE packages will not be built."
      ENV.append 'DISABLE_PKGS', "xpce"
    end
=======
    ENV.append 'DISABLE_PKGS', "jpl" unless build.include? "with-jpl"
    ENV.append 'DISABLE_PKGS', "xpce" unless build.include? 'with-xpce'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

    # SWI-Prolog's Makefiles don't add CPPFLAGS to the compile command, but do
    # include CIFLAGS. Setting it here. Also, they clobber CFLAGS, so including
    # the Homebrew-generated CFLAGS into COFLAGS here.
    ENV['CIFLAGS'] = ENV['CPPFLAGS']
    ENV['COFLAGS'] = ENV['CFLAGS']

    # Build the packages unless --lite option specified
    args << "--with-world" unless build.include? "lite"

    # './prepare' prompts the user to build documentation
    # (which requires other modules). '3' is the option
    # to ignore documentation.
    system "echo '3' | ./prepare" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/swipl", "--version"
  end
end
