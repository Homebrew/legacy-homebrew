require 'formula'

class Qt < Formula
  homepage 'http://qt.nokia.com/'
  url 'http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.2.tar.gz'
  md5 '3c1146ddf56247e16782f96910a8423b'

  bottle do
    version 1
    sha1 'dfa0daa951e889a2548b1cff66759b449b5a6b98' => :mountainlion
    sha1 '0905eb8b2c5a9bae0d1f9a8234173daba680c48c' => :lion
    sha1 'c37ac19d54c4684d8996a0ee96cdf971bd2c1f7b' => :snowleopard
  end

  head 'git://gitorious.org/qt/qt.git', :branch => 'master'

<<<<<<< HEAD
  fails_with :clang do
    build 421
  end
=======
  option :universal
  option 'with-qtdbus', 'Enable QtDBus module'
  option 'with-qt3support', 'Enable deprecated Qt3Support module'
  option 'with-demos-examples', 'Eanble Qt demos and examples'
  option 'with-debug-and-release', 'Compile Qt in debug and release mode'
  option 'developer', 'Compile and link Qt with developer options'

  depends_on "d-bus" if build.include? 'with-qtdbus'
  depends_on 'sqlite' if MacOS.leopard?
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  fails_with :clang do
    build 421
  end

  def patches
    # fixes conflict on osx 10.5. See qt bug:
    # https://bugreports.qt-project.org/browse/QTBUG-23258
    if MacOS.leopard?
      "http://bugreports.qt-project.org/secure/attachment/26712/Patch-Qt-4.8-for-10.5"
    # add support for Mountain Lion
    # should be unneeded for 4.8.3
    elsif MacOS.mountain_lion?
      [ "https://qt.gitorious.org/qt/qt/commit/422f1b?format=patch",
        "https://qt.gitorious.org/qt/qt/commit/665355?format=patch",
        "https://raw.github.com/gist/3187034/893252db0ae3bb9bb5fa3ff7c530c7978399b101/0001-Fix-WebKit-on-OS-X-Mountain-Lion.patch" ]
    end

  end

  def install
    # Apply binary git patch; normal patch ignores this.
    # TODO: Autodetect binary patches and apply them correctly.
    system "git apply --exclude=*/QtWebKit.pro 002-homebrew.diff" if MacOS.mountain_lion?

    ENV.append "CXXFLAGS", "-fvisibility=hidden"
    args = ["-prefix", prefix,
            "-system-zlib",
            "-confirm-license", "-opensource",
            "-cocoa", "-fast" ]

    # See: https://github.com/mxcl/homebrew/issues/issue/744
    args << "-system-sqlite" if MacOS.leopard?

    args << "-plugin-sql-mysql" if (HOMEBREW_CELLAR+"mysql").directory?

    if build.include? 'with-qtdbus'
      args << "-I#{Formula.factory('d-bus').lib}/dbus-1.0/include"
      args << "-I#{Formula.factory('d-bus').include}/dbus-1.0"
    end

    if build.include? 'with-qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    unless build.include? 'with-demos-examples'
      args << "-nomake" << "demos" << "-nomake" << "examples"
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    if build.include? 'with-debug-and-release'
      args << "-debug-and-release"
      # Debug symbols need to find the source so build in the prefix
      mv "../qt-everywhere-opensource-src-#{version}", "#{prefix}/src"
      cd "#{prefix}/src"
    else
      args << "-release"
    end

    args << '-developer-build' if build.include? 'developer'

    # Needed for Qt 4.8.1 due to attempting to link moc with gcc.
    ENV['LD'] = ENV.cxx

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # stop crazy disk usage
    (prefix+'doc/html').rmtree
    (prefix+'doc/src').rmtree
    # what are these anyway?
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink

    # Some config scripts will only find Qt in a "Frameworks" folder
    # VirtualBox is an example of where this is needed
    # See: https://github.com/mxcl/homebrew/issues/issue/745
    cd prefix do
      ln_s lib, prefix + "Frameworks"
    end

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

  def test
    system "#{bin}/qmake", "--version"
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end
