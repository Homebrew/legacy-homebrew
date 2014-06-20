require 'formula'

class Libcaca < Formula
  homepage 'http://caca.zoy.org/wiki/libcaca'
  url 'http://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz'
  version '0.99b19'
  sha1 'ed138f3717648692113145b99a80511178548010'

  bottle do
    cellar :any
    sha1 "15b7870ac1296c25b0650408bc6f6606e28d7108" => :mavericks
    sha1 "f98c991cab842376c714192d650b91c8eece7e7a" => :mountain_lion
    sha1 "bd28b6f61505fbf474de658c7ae169da3c3a4366" => :lion
  end

  option 'with-imlib2', 'Build with Imlib2 support'

  depends_on :x11 if build.with? "imlib2"

  if build.with? "imlib2"
    depends_on 'pkg-config' => :build
    depends_on 'imlib2' => :optional
  end

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
    inreplace 'python/Makefile.in', '$(am__py_compile) --destdir "$(DESTDIR)"', "$(am__py_compile) --destdir \"$(cacadir)\""

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
    system "make install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
