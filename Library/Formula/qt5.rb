require "formula"

class Qt5HeadDownloadStrategy < GitDownloadStrategy
  include FileUtils

  def stage
    cached_location.cd { reset }
    quiet_safe_system "git", "clone", cached_location, "."
    ln_s cached_location, "qt"
    quiet_safe_system "./init-repository", "--mirror", "#{Dir.pwd}/"
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
  url "http://qtmirror.ics.com/pub/qtproject/official_releases/qt/5.3/5.3.2/single/qt-everywhere-opensource-src-5.3.2.tar.gz"
  mirror "http://download.qt-project.org/official_releases/qt/5.3/5.3.2/single/qt-everywhere-opensource-src-5.3.2.tar.gz"
  sha1 "502dd2db1e9ce349bb8ac48b4edf7f768df1cafe"

  bottle do
    revision 1
    sha1 "a622384b646da163271514546498a5fcd53203b7" => :yosemite
    sha1 "06b31931f5b75352f605a7d22dbc9a66b2583002" => :mavericks
    sha1 "8056e8b4c814b3e0044db7eb11457ba7c6509559" => :mountain_lion
  end

  # Patch to fix compile errors on Yosemite. Can be removed with 5.4.
  # https://bugreports.qt-project.org/browse/QTBUG-41136
  patch :DATA

  head "https://gitorious.org/qt/qt5.git", :branch => "5.3",
    :using => Qt5HeadDownloadStrategy, :shallow => false

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option :universal
  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "developer", "Build and link with developer options"
  option "with-oci", "Build with Oracle OCI plugin"

  # Snow Leopard is untested and support is being officially removed in 5.4
  # https://qt.gitorious.org/qt/qtbase/commit/5be81925d7be19dd0f1022c3cfaa9c88624b1f08
  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "d-bus" => :optional
  depends_on :mysql => :optional
  depends_on :xcode => :build

  depends_on OracleHomeVar if build.with? "oci"

  deprecated_option "qtdbus" => "with-d-bus"

  def install
    ENV.universal_binary if build.universal?
    args = ["-prefix", prefix,
            "-system-zlib",
            "-qt-libpng", "-qt-libjpeg",
            "-confirm-license", "-opensource",
            "-nomake", "tests",
            "-release"]

    args << "-nomake" << "examples" if build.without? "examples"

    # https://bugreports.qt-project.org/browse/QTBUG-34382
    args << "-no-xcb"

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

    # configure saved the PKG_CONFIG_LIBDIR set up by superenv; remove it
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

__END__
diff --git a/qtmultimedia/src/plugins/avfoundation/mediaplayer/avfmediaplayersession.mm b/qtmultimedia/src/plugins/avfoundation/mediaplayer/avfmediaplayersession.mm
index a73974c..d3f3eae 100644
--- a/qtmultimedia/src/plugins/avfoundation/mediaplayer/avfmediaplayersession.mm
+++ b/qtmultimedia/src/plugins/avfoundation/mediaplayer/avfmediaplayersession.mm
@@ -322,7 +322,7 @@ static void *AVFMediaPlayerSessionObserverCurrentItemObservationContext = &AVFMe
     //AVPlayerItem "status" property value observer.
     if (context == AVFMediaPlayerSessionObserverStatusObservationContext)
     {
-        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
+        AVPlayerStatus status = (AVPlayerStatus)[[change objectForKey:NSKeyValueChangeNewKey] integerValue];
         switch (status)
         {
             //Indicates that the status of the player is not yet known because
