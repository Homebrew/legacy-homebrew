class Qt < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"

  stable do
    url "https://download.qt.io/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz"
    mirror "https://www.mirrorservice.org/sites/download.qt-project.org/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz"
    sha256 "e2882295097e47fe089f8ac741a95fef47e0a73a3f3cdf21b56990638f626ea0"
  end

  bottle do
    revision 6
    sha1 "bedfe4e950676a85f9653732d33767fbcce45da5" => :yosemite
    sha1 "8ee072473ababd49fe85bc6f9bf5ddcdafea8c26" => :mavericks
    sha1 "668ac1a65811e0ff23230a698725b383c61c1d13" => :mountain_lion
  end

  head "https://code.qt.io/qt/qt.git", :branch => "4.8"

  option :universal
  option "with-qt3support", "Build with deprecated Qt3Support module support"
  option "with-docs", "Build documentation"
  option "with-developer", "Build and link with developer options"

  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional
  depends_on "postgresql" => :optional

  deprecated_option "qtdbus" => "with-d-bus"
  deprecated_option "developer" => "with-developer"

  def install
    ENV.universal_binary if build.universal?

    args = ["-prefix", prefix,
            "-system-zlib",
            "-qt-libtiff", "-qt-libpng", "-qt-libjpeg",
            "-confirm-license", "-opensource",
            "-nomake", "demos", "-nomake", "examples",
            "-cocoa", "-fast", "-release"]

    if ENV.compiler == :clang
      args << "-platform"

      if MacOS.version >= :mavericks
        args << "unsupported/macx-clang-libc++"
      else
        args << "unsupported/macx-clang"
      end
    end

    args << "-plugin-sql-mysql" if build.with? "mysql"
    args << "-plugin-sql-psql" if build.with? "postgresql"

    if build.with? "d-bus"
      dbus_opt = Formula["d-bus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if build.with? "qt3support"
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    args << "-nomake" << "docs" if build.without? "docs"

    if MacOS.prefer_64_bit? || build.universal?
      args << "-arch" << "x86_64"
    end

    if !MacOS.prefer_64_bit? || build.universal?
      args << "-arch" << "x86"
    end

    args << "-developer-build" if build.with? "developer"

    system "./configure", *args
    system "make"
    ENV.j1
    system "make", "install"

    # what are these anyway?
    (bin+"pixeltool.app").rmtree
    (bin+"qhelpconverter.app").rmtree
    # remove porting file for non-humans
    (prefix+"q3porting.xml").unlink if build.without? "qt3support"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    Pathname.glob("#{bin}/*.app") { |app| mv app, prefix }
  end

  test do
    system "#{bin}/qmake", "-project"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
