require 'formula'

class SwiProlog < Formula
  homepage 'http://www.swi-prolog.org/'
  url 'http://www.swi-prolog.org/download/stable/src/pl-6.2.1.tar.gz'
  sha256 'c5ceac0a23e6a2ab706a10987cb87a0cfe4e5c3d01600f6c5e178846310ea7e8'

  head 'git://www.swi-prolog.org/home/pl/git/pl.git'

  option 'lite', "Disable all packages"
  option 'with-jpl', "Enable JPL (Java Prolog Bridge)"
  option 'with-xpce', "Enable XPCE (Prolog Native GUI Library)"

  depends_on 'readline'
  depends_on 'gmp'

  if build.include? 'with-xpce'
    depends_on 'pkg-config' => :build
    depends_on :x11
    depends_on 'jpeg'
  end

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
    ENV.append 'DISABLE_PKGS', "jpl" unless build.include? "with-jpl"
    ENV.append 'DISABLE_PKGS', "xpce" unless build.include? 'with-xpce'

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
