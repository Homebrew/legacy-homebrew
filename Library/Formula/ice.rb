class Ice < Formula
  homepage "https://www.zeroc.com/"
  revision 1

  stable do
    url "https://www.zeroc.com/download/Ice/3.5/Ice-3.5.1.tar.gz"
    sha1 "63599ea22a1e9638a49356682c9e516b7c2c454f"

    # 1. FIXTHIS: document the first patch
    # 2. Patch to fix build with libc++, reported upstream:
    # https://www.zeroc.com/forums/bug-reports/6152-mavericks-build-failure-because-unexported-symbols.html
    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Ice/Stable/icestable.diff"
      sha1 "081805e94f9620d99806a2696a296e30a65f6996"
    end
  end

  devel do
    url "https://www.zeroc.com/download/Ice/3.6/Ice-3.6b.tar.gz"
    sha1 "dcab7e14b3e42fa95af58f7e804f6fd9a17cb6b2"

    # Review this before stable lands.
    depends_on :macos => :mavericks
  end

  option "with-docs", "Install documentation"
  option "with-demos", "Build demos"

  deprecated_option "doc" => "with-docs"
  deprecated_option "demo" => "with-demos"

  depends_on "berkeley-db"
  depends_on "mcpp"
  depends_on "openssl"
  depends_on :python => :optional

  def install
    ENV.O2

    # Everything else in the original patch has been fixed by upstream for the devel release.
    inreplace "cpp/config/Make.rules.Darwin", "= xcrun clang++", "?= g++" if build.devel?

    # what do we want to build?
    wb = "config src include"
    wb += " doc" if build.with? "docs"
    wb += " demo" if build.with? "demos"
    inreplace "cpp/Makefile" do |s|
      s.change_make_var! "SUBDIRS", wb
    end

    args = %W[
      prefix=#{prefix}
      install_mandir=#{man1}
      install_slicedir=#{share}/Ice-3.5/slice
      embedded_runpath_prefix=#{prefix}
      OPTIMIZE=yes
    ]
    args << "CXXFLAGS=#{ENV.cflags} -Wall -D_REENTRANT"

    # Unset ICE_HOME as it interferes with the build
    ENV.delete("ICE_HOME")

    cd "cpp" do
      system "make", *args
      system "make", "install", *args
    end

    cd "php" do
      system "make", *args
      system "make", "install", *args
    end

    if build.with? "python"
      args << "install_pythondir=#{lib}/python2.7/site-packages"
      args << "install_libdir=#{lib}/python2.7/site-packages"
      cd "py" do
        system "make", *args
        system "make", "install", *args
      end
    end

    libexec.install "#{lib}/ImportKey.class"
  end

  test do
    system "#{bin}/icebox", "--version"
  end

  def caveats
    <<-EOS.undent
      To enable IcePHP, you will need to change your php.ini
      to load the IcePHP extension. You can do this by adding
      IcePHP.dy to your list of extensions:

          extension=#{prefix}/php/IcePHP.dy

      Typical Ice PHP scripts will also expect to be able to "require Ice.php".

      You can ensure this is possible by appending the path to
      Ice's PHP includes to your global include_path in php.ini:

          include_path=<your-original-include-path>:#{prefix}/php

      However, you can also accomplish this on a script-by-script basis
      or via .htaccess if you so desire...
      EOS
  end
end
