require 'formula'

class Qt < Formula
  homepage "http://qt-project.org/"

  stable do
    # Mirror rather than source set as primary because source is very slow.
    url "http://qtmirror.ics.com/pub/qtproject/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"
    mirror "http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"
    sha1 "ddf9c20ca8309a116e0466c42984238009525da6"

    # This patch should be able to be removed with the next stable Qt4 release.
    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/440e3cafde5bf6ec6f50cd28fa5bf89c280f1b53/Homebrew_Resources/Qt/qt4patch.diff"
      sha1 "57246a33460246118a1fab7460c79f2077d3a929"
    end
  end

  bottle do
    revision 5
    sha1 "34d66e17aaed4d2067297d4a64482d56f2382339" => :mavericks
    sha1 "9ab96caa65e8b707deeb27caaff9ad8b1e906b2c" => :mountain_lion
    sha1 "18b1d1a4aa89f92c4b9a9f202a95cc0896e03a9d" => :lion
  end

  head "git://gitorious.org/qt/qt.git", :branch => '4.8'

  option :universal
  option 'with-qt3support', 'Build with deprecated Qt3Support module support'
  option 'with-docs', 'Build documentation'
  option 'developer', 'Build and link with developer options'

  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional
  depends_on "postgresql" => :optional

  deprecated_option "qtdbus" => "with-d-bus"

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

    args << "-plugin-sql-mysql" if build.with? 'mysql'
    args << "-plugin-sql-psql" if build.with? 'postgresql'

    if build.with? 'd-bus'
      dbus_opt = Formula["d-bus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if build.with? 'qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    args << "-nomake" << "docs" if build.without? 'docs'

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    args << '-developer-build' if build.include? 'developer'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # what are these anyway?
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink if build.without? 'qt3support'

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
    system "#{bin}/qmake", '-project'
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
