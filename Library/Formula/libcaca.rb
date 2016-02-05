class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "https://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz"
  version "0.99b19"
  sha256 "128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4"

  bottle do
    cellar :any
    revision 1
    sha256 "ba475a145203197f637059f20dfcb5d8cfb34615ce30bfe342fbe7887ebcad41" => :el_capitan
    sha256 "1d02b3264c1665a8f6af5d88ba944bc1009ee7e553ae8decfff89615b7dc79d9" => :yosemite
    sha256 "511f48aa84b45eb509de89296102517bd77c25347999cf1d733bc8593c95a00b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2" => :optional
  depends_on :x11 if build.with? "imlib2"

  fails_with :llvm do
    cause "Unsupported inline asm: input constraint with a matching output constraint of incompatible type"
  end

  def install
    # Some people can't compile when Java is enabled. See:
    # https://github.com/Homebrew/homebrew/issues/issue/2049

    # Don't build csharp bindings
    # Don't build ruby bindings; fails for adamv w/ Homebrew Ruby 1.9.2

    # Fix --destdir issue.
    #   ../.auto/py-compile: Missing argument to --destdir.
    inreplace "python/Makefile.in", '$(am__py_compile) --destdir "$(DESTDIR)"', "$(am__py_compile) --destdir \"$(cacadir)\""

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-doc",
            "--disable-slang",
            "--disable-java",
            "--disable-csharp",
            "--disable-ruby"]

    # fix missing x11 header check: https://github.com/Homebrew/homebrew/issues/28291
    args << "--disable-x11" if build.without? "imlib2"

    system "./configure", *args
    system "make"
    ENV.j1 # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
