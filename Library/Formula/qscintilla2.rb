require 'formula'

class Qscintilla2 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/qscintilla/intro'
  url "https://downloads.sf.net/project/pyqt/QScintilla2/QScintilla-2.8.3/QScintilla-gpl-2.8.3.tar.gz"
  sha1 "d3b4f0dc7358591c122518d932f797ae3e3dd9d4"

  bottle do
    sha1 "fa508a94662ed80738179efb88c8d9a80ce1e349" => :yosemite
    sha1 "76f43d61489d59c0df78c2b206f132842b1e893c" => :mavericks
    sha1 "1f5d86d06e559fa543611121701eb88098e6d2d4" => :mountain_lion
  end

  depends_on :python => :recommended
  depends_on :python3 => :optional

  option "without-plugin", "Skip building the Qt Designer plugin"

  if build.with? "python3"
    depends_on "pyqt" => "with-python3"
  else
    depends_on "pyqt"
  end

  def install
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang and MacOS.version >= :mavericks
      spec = "unsupported/macx-clang-libc++"
    else
      spec = "macx-g++"
    end
    args = %W[-config release -spec #{spec}]

    cd 'Qt4Qt5' do
      inreplace 'qscintilla.pro' do |s|
        s.gsub! '$$[QT_INSTALL_LIBS]', lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", "#{prefix}/trans"
        s.gsub! "$$[QT_INSTALL_DATA]", "#{prefix}/data"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! '$$[QT_INSTALL_LIBS]', lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system "qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    # Add qscintilla2 features search path, since it is not installed in Qt keg's mkspecs/features/
    ENV["QMAKEFEATURES"] = "#{prefix}/data/mkspecs/features"

    cd 'Python' do
      Language::Python.each_python(build) do |python, version|
        (share/"sip").mkpath
        system python, "configure.py", "-o", lib, "-n", include,
                         "--apidir=#{prefix}/qsci",
                         "--destdir=#{lib}/python#{version}/site-packages/PyQt4",
                         "--qsci-sipdir=#{share}/sip",
                         "--pyqt-sipdir=#{HOMEBREW_PREFIX}/share/sip",
                         "--spec=#{spec}"
        system 'make'
        system 'make', 'install'
        system "make", "clean"
      end
    end

    if build.with? "plugin"
      mkpath prefix/"plugins/designer"
      cd "designer-Qt4Qt5" do
        inreplace "designer.pro" do |s|
          s.sub! "$$[QT_INSTALL_PLUGINS]", "#{prefix}/plugins"
          s.sub! "$$[QT_INSTALL_LIBS]", "#{lib}"
        end
        system "qmake", "designer.pro", *args
        system "make"
        system "make", "install"
      end
      # symlink Qt Designer plugin (note: not removed on qscintilla2 formula uninstall)
      ln_sf prefix/"plugins/designer/libqscintillaplugin.dylib",
            Formula["qt"].opt_prefix/"plugins/designer/"
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import PyQt4.Qsci
      assert("QsciLexer" in dir(PyQt4.Qsci))
    EOS
    Language::Python.each_python(build) do |python, version|
      system python, "test.py"
    end
  end
end
