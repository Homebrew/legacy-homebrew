require 'formula'

class QtWkhtmltopdf < Formula
  homepage 'http://qt-project.org/'
  if MacOS.version < :mavericks
    url 'http://download.qt-project.org/official_releases/qt/4.8/4.8.5/qt-everywhere-opensource-src-4.8.5.tar.gz'
    sha1 '745f9ebf091696c0d5403ce691dc28c039d77b9e'
  else
    url 'git://gitorious.org/qt/qt.git', :branch => '4.8'
    version '4.8'
  end

  option :universal

  depends_on 'libpng'
  depends_on 'libtiff' # note: libtiff requires jpeg so we don't need to explicitly require it

  keg_only :provided_by_osx
  keg_only "This QT formula is only used to build a patched, statically compiled wkhtmltopdf"

  def patches
    patches = []

    # Static compilation of WebKit, based on PhantomJS QtWebKit.pro and Antialize configure fixes
    # based on https://qt.gitorious.org/qt/antializes-qt/commit/1c59d81230e2deb4b59b2ba175ebc89d47b7c5f3
    # based on https://github.com/ariya/phantomjs/blob/master/src/qt/src/3rdparty/webkit/Source/WebKit/qt/QtWebKit.pro
    # see also https://code.google.com/p/wkhtmltopdf/wiki/compilation#commentlist comment by arnedebruijn on Aug 6, 2013
    # patch from comment above 'https://gist.github.com/arbruijn/6165458/raw/c5f1b702585694737243c0b887b790db03e0406b/qtwebkit-static-from-ariya-phantomjs-31157fbb98a9765c0043847a3a41359838aad0d0.diff',
    patches << 'https://gist.github.com/npinchot/5a8feefed0af5a3b702a/raw/6b9905ed29169906cf0986c60c1f8bc09af6403b/gistfile1.diff'

    # Made by wkhtmltopdf
    # https://qt.gitorious.org/qt/antializes-qt/commit/6f58ce5a2c6ab6234c9ff2b84e8cc9e14f59abb2
    if MacOS.version < :mavericks
      patches << 'https://qt.gitorious.org/qt/antializes-qt/commit/6f58ce5a2c6ab6234c9ff2b84e8cc9e14f59abb2.patch'
    else
      # need a different patch if using 4.8 branch
      patches << 'https://gist.github.com/npinchot/c7ca584e5bb4aafcfef7/raw/e949a62b92b832976da49d9acf24bcc90670f94f/gistfile1.diff'
    end

    # Patches for custom QT build from antialize for wkhtmltopdf
    patches +=
    [
      # Remove some graphics dependencies
      # https://qt.gitorious.org/qt/antializes-qt/commit/890911b89ed4c7cd10d0b9fe332c32a5b93ea699
      'https://qt.gitorious.org/qt/antializes-qt/commit/890911b89ed4c7cd10d0b9fe332c32a5b93ea699.patch',

      # Add wkhtmltopdf definition to qwebframe.h
      # https://qt.gitorious.org/qt/antializes-qt/commit/59744a464ffaf5fab0b4f30bfc7dca42c2198954
      'https://qt.gitorious.org/qt/antializes-qt/commit/59744a464ffaf5fab0b4f30bfc7dca42c2198954.patch',

      # Add support for links, hyperlinks and outlines to the pdf print system
      # https://qt.gitorious.org/qt/antializes-qt/commit/16db67a28efbed8e4be741787be5e49663acdc6a
      'https://qt.gitorious.org/qt/antializes-qt/commit/16db67a28efbed8e4be741787be5e49663acdc6a.patch',

      # Output pdf creation date in local time according to pdf spec
      # https://qt.gitorious.org/qt/antializes-qt/commit/e0c415b7272bc3f29bce3b043417388914eaa998
      'https://qt.gitorious.org/qt/antializes-qt/commit/e0c415b7272bc3f29bce3b043417388914eaa998.patch',

      # Add support for not compressing pdf files
      # https://qt.gitorious.org/qt/antializes-qt/commit/fc1414a0db5305385279bf701d1066ec34ce4258
      'https://qt.gitorious.org/qt/antializes-qt/commit/fc1414a0db5305385279bf701d1066ec34ce4258.patch',

      # Add support for pdf forms in pdf print engine
      # https://qt.gitorious.org/qt/antializes-qt/commit/a1654e5519c97c0849bc70fd8ca40fc7a2b3cd71
      'https://qt.gitorious.org/qt/antializes-qt/commit/a1654e5519c97c0849bc70fd8ca40fc7a2b3cd71.patch',

      # Do not print the background on body elements if it happes to be white
      # https://qt.gitorious.org/qt/antializes-qt/commit/2353e5d9b2e26dd279e923424a197d51f1db3b2f
      'https://qt.gitorious.org/qt/antializes-qt/commit/2353e5d9b2e26dd279e923424a197d51f1db3b2f.patch',

      # Add support for using a mediatype diffrent from _print_ when printing
      # https://qt.gitorious.org/qt/antializes-qt/commit/b832c04289ebebd7660a2cec80371c16c788b9e5
      'https://qt.gitorious.org/qt/antializes-qt/commit/b832c04289ebebd7660a2cec80371c16c788b9e5.patch',

      # Add webpage print control API
      # https://qt.gitorious.org/qt/antializes-qt/commit/30675a1f42e802e616603c324577b75773ea17f7
      'https://qt.gitorious.org/qt/antializes-qt/commit/30675a1f42e802e616603c324577b75773ea17f7.patch',

      # Add support for custom print shrinking
      # https://qt.gitorious.org/qt/antializes-qt/commit/fe8254be30a7f48389ce2cbff3f41ab79b8c7d0d
      'https://qt.gitorious.org/qt/antializes-qt/commit/fe8254be30a7f48389ce2cbff3f41ab79b8c7d0d.patch',

      # Add property viewBoxClip to QSvgGenerator allowing for not including objects outside the viewBox
      # https://qt.gitorious.org/qt/antializes-qt/commit/cbbe807b5b50ce2ddf3fc4008669814b63306dbe
      'https://qt.gitorious.org/qt/antializes-qt/commit/cbbe807b5b50ce2ddf3fc4008669814b63306dbe.patch',

      # Add image printing improvments
      # https://qt.gitorious.org/qt/antializes-qt/commit/adf09c9ef8757f9bc83f0692c1258b41ca41fc44
      'https://qt.gitorious.org/qt/antializes-qt/commit/adf09c9ef8757f9bc83f0692c1258b41ca41fc44.patch',

      # Prevent page breaks in table rows.
      # https://qt.gitorious.org/qt/antializes-qt/commit/27b518a8f5695a7933ff7f38faef5ee746b28df1
      'https://qt.gitorious.org/qt/antializes-qt/commit/27b518a8f5695a7933ff7f38faef5ee746b28df1.patch',

      # Repeat thead and tfoot when table contains page breaks.
      # https://qt.gitorious.org/qt/antializes-qt/commit/7db70ae32426c9e2bb8a0440e6663ee85c6157c7
      'https://qt.gitorious.org/qt/antializes-qt/commit/7db70ae32426c9e2bb8a0440e6663ee85c6157c7.patch',

      # Pass page height through to print context from web frame printer
      # https://qt.gitorious.org/qt/antializes-qt/commit/d4cb128e19c2108e234db113a021a88cf59a160d
      'https://qt.gitorious.org/qt/antializes-qt/commit/d4cb128e19c2108e234db113a021a88cf59a160d.patch',

      # Improve font kerning
      # https://qt.gitorious.org/qt/antializes-qt/commit/d8fb938c89f3e89374efa0e93dad79b44614d459
      'https://qt.gitorious.org/qt/antializes-qt/commit/d8fb938c89f3e89374efa0e93dad79b44614d459.patch',

      # Table page-break improvements
      # https://qt.gitorious.org/qt/antializes-qt/commit/bb3ffc86272326b9f2ec3f2cd2523717e9f28758
      'https://qt.gitorious.org/qt/antializes-qt/commit/bb3ffc86272326b9f2ec3f2cd2523717e9f28758.patch',

      # Ensure we have a first cell to measure when checking required table height
      # https://qt.gitorious.org/qt/antializes-qt/commit/08c134d0b8a541cbb7ab6396baff1f07fe437d98
      'https://qt.gitorious.org/qt/antializes-qt/commit/08c134d0b8a541cbb7ab6396baff1f07fe437d98.patch',
    ]

    return patches
  end

  def install
    ENV.universal_binary if build.universal?

    # don't build corewlan, it's broken as of Jan 24, 2014, and we don't need it for wkhtmltopdf
    inreplace 'configure', /CFG_COREWLAN=auto/, 'CFG_COREWLAN=no'

    # most args are taken from:
    # https://github.com/antialize/wkhtmltopdf/blob/master/static_qt_conf_base
    # https://github.com/antialize/wkhtmltopdf/blob/master/static_qt_conf_osx
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

            # turn this off or we will get duplicate symbols
            "-no-script",

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

    if MacOS.version < :mavericks
      # these are no longer in the 4.8 branch
      # what are these anyway?
      (bin+'pixeltool.app').rmtree
      (bin+'qhelpconverter.app').rmtree
      # remove porting file for non-humans
      (prefix+'q3porting.xml').unlink if build.without? 'qt3support'
    end

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
