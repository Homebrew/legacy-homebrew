require "formula"

class Qt5HeadDownloadStrategy < GitDownloadStrategy
  def stage
    cached_location.cd { reset }
    quiet_safe_system "git", "clone", cached_location, "."
    ln_s cached_location, "qt"
    quiet_safe_system "./init-repository", { :quiet_flag => "-q" }, "--mirror", "#{Dir.pwd}/"
    rm "qt"
  end
end

class OracleHomeVar < Requirement
  fatal true
  satisfy ENV["ORACLE_HOME"]

  def message; <<-EOS.undent
      To use --with-oci you have to set the ORACLE_HOME environment variable.
      Check Oracle Instant Client documentation for more information.
    EOS
  end
end

class Qt5 < Formula
  homepage "http://qt-project.org/"
  url "http://qtmirror.ics.com/pub/qtproject/official_releases/qt/5.4/5.4.0/single/qt-everywhere-opensource-src-5.4.0.tar.xz"
  mirror "http://download.qt-project.org/official_releases/qt/5.4/5.4.0/single/qt-everywhere-opensource-src-5.4.0.tar.xz"
  sha1 "2f5558b87f8cea37c377018d9e7a7047cc800938"

  bottle do
    sha1 "072ed2c806664fd1da3ba7c90c8e4887509fb91b" => :yosemite
    sha1 "1ca730d96a962a5c4fcbd605542b7bfb528d6c58" => :mavericks
    sha1 "a6bbd39629a69c35c8a5d5e8ede4b6c752e3aecf" => :mountain_lion
  end

  head "https://gitorious.org/qt/qt5.git", :branch => "5.4",
    :using => Qt5HeadDownloadStrategy, :shallow => false

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option :universal
  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "developer", "Build and link with developer options"
  option "with-oci", "Build with Oracle OCI plugin"

  # Snow Leopard is untested and support has been removed in 5.4
  # https://qt.gitorious.org/qt/qtbase/commit/5be81925d7be19dd0f1022c3cfaa9c88624b1f08
  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "d-bus" => :optional
  depends_on :mysql => :optional
  depends_on :xcode => :build

  # There needs to be an OpenSSL dep here ideally, but qt keeps ignoring it.
  # Keep nagging upstream for a fix to this problem, and revision when possible.
  # https://github.com/Homebrew/homebrew/pull/34929
  # https://bugreports.qt-project.org/browse/QTBUG-42161

  depends_on OracleHomeVar if build.with? "oci"

  deprecated_option "qtdbus" => "with-d-bus"

  def install
    ENV.universal_binary if build.universal?

    args = ["-prefix", prefix,
            "-system-zlib",
            "-qt-libpng", "-qt-libjpeg",
            "-confirm-license", "-opensource",
            "-nomake", "tests", "-release"]

    args << "-nomake" << "examples" if build.without? "examples"

    args << "-plugin-sql-mysql" if build.with? "mysql"

    if build.with? "d-bus"
      dbus_opt = Formula["d-bus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << "-arch" << "x86_64"
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << "-arch" << "x86"
    end

    if build.with? "oci"
      args << "-I#{ENV['ORACLE_HOME']}/sdk/include"
      args << "-L{ENV['ORACLE_HOME']}"
      args << "-plugin-sql-oci"
    end

    args << "-developer-build" if build.include? "developer"

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"
    if build.with? "docs"
      system "make", "docs"
      system "make", "install_docs"
    end

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    # configure saved PKG_CONFIG_LIBDIR set up by superenv; remove it
    # see: https://github.com/Homebrew/homebrew/issues/27184
    inreplace prefix/"mkspecs/qconfig.pri", /\n\n# pkgconfig/, ""
    inreplace prefix/"mkspecs/qconfig.pri", /\nPKG_CONFIG_.*=.*$/, ""

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
