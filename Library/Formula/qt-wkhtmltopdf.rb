require 'formula'

class QtWkhtmltopdf < Formula
  homepage 'http://qt-project.org/'
  url 'https://github.com/wkhtmltopdf/qt.git', :branch => 'wk_4.8.6'
  version '4.8.6'

  option :universal

  depends_on 'libpng'
  depends_on 'libtiff' # note: libtiff requires jpeg so we don't need to explicitly require it

  keg_only :provided_by_osx
  keg_only "This QT formula is only used to build a patched, statically compiled wkhtmltopdf"

  def install
    ENV.universal_binary if build.universal?

    # most args are taken from:
    # https://github.com/wkhtmltopdf/wkhtmltopdf/blob/master/static_qt_conf_base
    # https://github.com/wkhtmltopdf/wkhtmltopdf/blob/master/static_qt_conf_osx
    args = ["-prefix", prefix,

            # open source license without prompting
            "-confirm-license", "-opensource",

            # use system libraries for most things
            "-system-zlib", "-qt-libmng", "-system-libtiff", "-system-libpng", "-system-libjpeg",

            # static build with cocoa
            "-static", "-cocoa", "-fast", "-release",

            # don't build things we don't need
            "-nomake", "demos", "-nomake", "examples", "-nomake", "tools", "-nomake", "docs", "-nomake", "translations", "-nomake", "tests",

            # OS X sdk
            "-sdk", "#{MacOS.sdk_path}",

            # requirements for wkhtmltopdf
            "-xmlpatterns", "-webkit", "-xrender", "-openssl", "-largefile", "-rpath",

            # raster graphics
            "-graphicssystem", "raster",

            # turn off things we don't need
            "-no-qt3support", "-no-javascript-jit",
            "-no-sql-ibase", "-no-sql-mysql", "-no-sql-odbc", "-no-sql-psql", "-no-sql-sqlite", "-no-sql-sqlite2",
          ]

    # we have to disable these to avoid triggering optimization code
    # that will fail in superenv (in --env=std, Qt seems aware of this)
    args << '-no-3dnow' << '-no-ssse3' << '-no-sse2' << '-no-sse' << '-no-mmx' if superenv?

    args << "-L#{MacOS::X11.lib}" << "-I#{MacOS::X11.include}" if MacOS::X11.installed?

    if ENV.compiler == :clang
        args << "-platform"

        if MacOS.version >= :mavericks
          args << "unsupported/macx-clang-libc++"
        else
          args << "unsupported/macx-clang"
        end
    end

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

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
