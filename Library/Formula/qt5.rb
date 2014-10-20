require "formula"

class Qt5HeadDownloadStrategy < GitDownloadStrategy
  include FileUtils

  def stage
    @clone.cd { reset }
    safe_system "git", "clone", @clone, "."
    ln_s @clone, "qt"
    safe_system "./init-repository", "--mirror", "#{Dir.pwd}/"
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
    sha1 "b2a204e963405aade40d9a88383beeec7301c7e2" => :mavericks
    sha1 "2744a6ee18b87ab1ab791ec136c3f95481713d2c" => :mountain_lion
    sha1 "6d327353447bdc56176f605e51d910fde032ad8d" => :lion
  end

  # Patch to fix compile errors on Yosemite. Can be removed with 5.4.
  # https://bugreports.qt-project.org/browse/QTBUG-41136
  patch :DATA

  head "git://gitorious.org/qt/qt5.git", :branch => "stable",
    :using => Qt5HeadDownloadStrategy, :shallow => false

  keg_only "Qt 5 conflicts Qt 4 (which is currently much more widely used)."

  option :universal
  option "with-docs", "Build documentation"
  option "with-examples", "Build examples"
  option "developer", "Build and link with developer options"
  option "with-oci", "Build with Oracle OCI plugin"

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
