require 'formula'

class Qt < Formula
  homepage 'http://qt-project.org/'
  if MacOS.version < :mavericks
    url 'http://download.qt-project.org/official_releases/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz'
    sha1 '745f9ebf091696c0d5403ce691dc28c039d77b9e'
  else
    # This is a snapshot of the current qt-4.8 branch. It's been used by a
    # bunch of people to get Qt working on Mavericks and 4.8.5 needs too many
    # patches to compile any time soon (January-ish):
    # http://permalink.gmane.org/gmane.comp.lib.qt.devel/13812
    url 'https://github.com/qtproject/qt/archive/f44310c25b372f494586dbb5b305f7e81ca63000.tar.gz'
    sha1 '51548326463068912fb4d9de04b0f6b2e267d064'
    # It would be nice if this was a real version number but unfortunately
    # that will mess with the bottles.
    version '4.8.5'
  end

  head 'git://gitorious.org/qt/qt.git', :branch => '4.8'

  bottle do
    revision 4
    sha1 '446f9ee06721c227b7b86f7c82bb84ffeca00379' => :mavericks
    sha1 '9014726e304c037401b788499fbc0e9bc1d332f8' => :mountain_lion
    sha1 'bfd7b572a3889cf2e20491af82186d5d42740315' => :lion
  end

  option :universal
  option 'with-qt3support', 'Build with deprecated Qt3Support module support'
  option 'with-docs', 'Build documentation'
  option 'developer', 'Build and link with developer options'

  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional

  odie 'qt: --with-qtdbus has been renamed to --with-d-bus' if build.with? "qtdbus"
  odie 'qt: --with-demos-examples is no longer supported' if build.with? "demos-examples"
  odie 'qt: --with-debug-and-release is no longer supported' if build.with? "debug-and-release"

  def install
    ENV.universal_binary if build.universal?

    args = ["-prefix", prefix,
            "-system-zlib",
            "-qt-libtiff", "-qt-libpng", "-qt-libjpeg",
            "-confirm-license", "-opensource",
            "-nomake", "demos", "-nomake", "examples",
            "-cocoa", "-fast", "-release"]

    # we have to disable these to avoid triggering optimization code
    # that will fail in superenv (in --env=std, Qt seems aware of this)
    args << '-no-3dnow' << '-no-ssse3' if superenv?

    args << "-L#{MacOS::X11.lib}" << "-I#{MacOS::X11.include}" if MacOS::X11.installed?

    if ENV.compiler == :clang
        args << "-platform"

        if MacOS.version >= :mavericks
          args << "unsupported/macx-clang-libc++"
        else
          args << "unsupported/macx-clang"
        end
    end

    args << "-plugin-sql-mysql" if build.with? 'mysql'

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
