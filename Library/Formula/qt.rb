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
    url 'https://github.com/qtproject/qt/archive/157da36977213237939df14608753bb3ec280f0b.tar.gz'
    sha1 '145b8eb6a6c2ccc1cc58ddcb03a1d33b153e0c15'
    # It would be nice if this was a real version number but unfortunately
    # that will mess with the bottles.
    version '4.8.5'

    resource 'libWebKitSystemInterfaceMavericks' do
      url 'http://trac.webkit.org/export/157771/trunk/WebKitLibraries/libWebKitSystemInterfaceMavericks.a'
      sha1 'fc5ebf85f637f9da9a68692df350e441c8ef5d7e'
      version '157771'
    end
  end

  head 'git://gitorious.org/qt/qt.git', :branch => '4.8'

  bottle do
    revision 3
    sha1 'ca4c5369dafffafc9e511448976b4778648aaf08' => :mavericks
    sha1 'cfd3ada87d28d422b0973848f40d40ffa0cfde22' => :mountain_lion
    sha1 '96fefa9bcd3919c265e79a48afaf76a09b734291' => :lion
  end

  option :universal
  option 'with-qt3support', 'Build with deprecated Qt3Support module support'
  option 'with-docs', 'Build documentation'
  option 'developer', 'Build and link with developer options'

  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional

  odie 'qt: --with-qtdbus has been renamed to --with-d-bus' if build.include? 'with-qtdbus'
  odie 'qt: --with-demos-examples is no longer supported' if build.include? 'with-demos-examples'
  odie 'qt: --with-debug-and-release is no longer supported' if build.include? 'with-debug-and-release'

  def patches
    p = []
    if MacOS.version >= :mavericks
      # Patches to fix compilation on Mavericks (http://github.com/mxcl/homebrew/pull/23793)
      unless build.head?
        p += [
          # Change Iff4d919d: Added a patch to let the WebKit's QNetworkReplyHandler.cpp compile at Mac OS X 10.9 Mavericks
          # (https://codereview.qt-project.org/#change,70438)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/ec13ef2a8b4adc7b9695e6d49876d826f89802ae/Change_Iff4d919d',
          # Change Ied51c868: Added a patch to let the WebKit's qgraphicswebview.cpp compile at Mac OS X 10.9 Mavericks
          # (https://codereview.qt-project.org/#change,70439)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/8834e194a0f4e0c99ef64064f6a86ddcb617f444/Change_Ied51c868',
          # Change Ic6330613: Added a patch to let the WebKit's NotificationPresenterClientQt.cpp compile at Mac OS X 10.9 Mavericks
          # (https://codereview.qt-project.org/#change,70440)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/9ee8460814204faa5cf5b1317fba5d1b14a563eb/Change_Ic6330613',
          # Change I2ad84441: Added a patch to let the WebKit's .pro file find the lib for Mavericks. This is needed to compile at Mac OS X 10.9 Mavericks
          # (https://codereview.qt-project.org/#change,70442)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/f73ea1979f4595fc463b2deb77987b389748e289/Change_I2ad84441',
          # Change I4c697a87: Added a patch to let the WebKit's platform/Timer.h compile at Mac OS X 10.9 Mavericks
          # (https://codereview.qt-project.org/#change,70443)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/9d5305f6bb01cf445893d09bf399097a53706d6a/Change+I4c697a87',
          # Change I31ad9a7a: Added a patch to let the WebKit's platform/Timer.cpp compile at Mac OS X 10.9 Mavericks
          # (https://codereview.qt-project.org/#change,70444)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/2f9a348e575f63d435c3d32a9c70c4c2d687542c/Change_I31ad9a7a',
          # Change Ieb30c115: Backported fix for WebKit libc++ support on OS X Mavricks
          # (https://codereview.qt-project.org/#change,70929)
          'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/ebdc1fbf8d1b9a65e797124fb64b709a7d71107d/Change_Ieb30c115',
        ]
      end

      p += [
        # Change Change I8fd619af: Added a patch to let the CLucene's FieldCachImpl.cpp compile at Mac OS X 10.9 Mavericks
        # (https://codereview.qt-project.org/#change,70437)
        'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/6d2597c4c61cca04ed56472fd1fd793798526ce6/Change_I8fd619af',
        # Change Iaedaff7c: Enable building with clang / libc++ on OS X 10.9 Mavericks
        # (https://codereview.qt-project.org/#change,70930)
        'https://gist.github.com/jensenb/aafb2c2d1e0fcce2994f/raw/cc0a38d67cb36b650a275af3825731ce1f2ba35c/Change_Iaedaff7c',
        # Change I04e1471d: Return the correct system font on OS X Mavericks.
        # (https://codereview.qt-project.org/#change,62261)
        'https://gist.github.com/mhemeryck/7487365/raw/adc0ba7a9b33b113ab3d15f545082703a51d3ccd/Change_I04e1471d',
      ]
    end
    p
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.append "CXXFLAGS", "-fvisibility=hidden"

    args = ["-prefix", prefix,
            "-system-zlib",
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
      dbus_opt = Formula.factory('d-bus').opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
    end

    if build.with? 'qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    unless build.with? 'docs'
      args << "-nomake" << "docs"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    args << '-developer-build' if build.include? 'developer'

    if MacOS.version >= :mavericks
      (buildpath/'src/3rdparty/webkit/WebKitLibraries').install resource('libWebKitSystemInterfaceMavericks')
    end

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
    frameworks.mkpath
    ln_s Dir["#{lib}/*.framework"], frameworks

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob(lib + '*.framework/Headers').each do |path|
      framework_name = File.basename(File.dirname(path), '.framework')
      ln_s path.realpath, include+framework_name
    end

    Pathname.glob(bin + '*.app').each do |path|
      mv path, prefix
    end
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
