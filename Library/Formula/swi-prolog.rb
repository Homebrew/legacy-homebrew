require "formula"

class SwiProlog < Formula
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/pl-6.6.6.tar.gz"
  sha1 "38cc6772a48fd412f50fc06e24e6e4673eb71d3b"

  devel do
    url "http://www.swi-prolog.org/download/devel/src/pl-7.1.16.tar.gz"
    sha1 "e80fc215f1ba5ab45b4c19e3e81321f6f2048091"
  end

  head do
    url "git://www.swi-prolog.org/home/pl/git/pl.git"

    depends_on "autoconf" => :build
  end

  option "lite", "Disable all packages"
  option "with-jpl", "Enable JPL (Java Prolog Bridge)"
  option "with-xpce", "Enable XPCE (Prolog Native GUI Library)"

  depends_on "readline"
  depends_on "gmp"
  depends_on "libarchive" => :optional

  if build.with? "xpce"
    depends_on "pkg-config" => :build
    depends_on :x11
    depends_on "jpeg"
  end

  # 10.5 versions of these are too old
  if MacOS.version <= :leopard
    depends_on "fontconfig"
    depends_on "expat"
  end

  fails_with :llvm do
    build 2335
    cause "Exported procedure chr_translate:chr_translate_line_info/3 is not defined"
  end

  def install
    # The archive package hard-codes a check for MacPort libarchive
    # Replace this with a check for Homebrew's libarchive, or nowhere
    if build.with? "libarchive"
      inreplace "packages/archive/configure.in", "/opt/local",
                                                 Formula["libarchive"].opt_prefix
    else
      ENV.append "DISABLE_PKGS", "archive"
    end

    args = ["--prefix=#{libexec}", "--mandir=#{man}"]
    ENV.append "DISABLE_PKGS", "jpl" if build.without? "jpl"
    ENV.append "DISABLE_PKGS", "xpce" if build.without? "xpce"

    # SWI-Prolog's Makefiles don't add CPPFLAGS to the compile command, but do
    # include CIFLAGS. Setting it here. Also, they clobber CFLAGS, so including
    # the Homebrew-generated CFLAGS into COFLAGS here.
    ENV["CIFLAGS"] = ENV.cppflags
    ENV["COFLAGS"] = ENV.cflags

    # Build the packages unless --lite option specified
    args << "--with-world" unless build.include? "lite"

    # './prepare' prompts the user to build documentation
    # (which requires other modules). '3' is the option
    # to ignore documentation.
    system "echo '3' | ./prepare" if build.head?
    system "./configure", *args
    system "make"
    system "make install"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/swipl", "--version"
  end
end
