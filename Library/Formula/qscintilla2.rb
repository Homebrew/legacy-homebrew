require 'formula'

class PythonEnvironment < Requirement
  fatal true

  satisfy do
    !(!Formula["python"].installed? && ARGV.include?("--without-python") && ARGV.include?("--with-python3"))
  end

  def message
    <<-EOS.undent
      You cannot use system Python 2 and Homebrew's Python 3
      simultaneously.
      Either `brew install python` or use `--without-python3`.
    EOS
  end
end

class Qscintilla2 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/qscintilla/intro'
  url 'https://downloads.sf.net/project/pyqt/QScintilla2/QScintilla-2.8/QScintilla-gpl-2.8.tar.gz'
  sha1 '3edf9d476d4e6af0706a4d33401667a38e3a697e'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.with? "python3"
    depends_on "pyqt" => "with-python3"
  else
    depends_on "pyqt"
  end

  def pythons
    pythons = []
    ["python", "python3"].each do |python|
      next if build.without? python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      pythons << [python, version]
    end
    pythons
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

      system "qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    cd 'Python' do
      pythons.each do |python, version|
        (share/"sip").mkpath
        system python, "configure.py", "-o", lib, "-n", include,
                         "--apidir=#{prefix}/qsci",
                         "--destdir=#{lib}/python#{version}/site-packages/PyQt4",
                         "--qsci-sipdir=#{share}/sip",
                         "--pyqt-sipdir=#{HOMEBREW_PREFIX}/share/sip",
                         "--spec=#{spec}"
        system 'make'
        system 'make', 'install'
        system "make", "clean" if pythons.length > 1
      end
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import PyQt4.Qsci
      assert("QsciLexer" in dir(PyQt4.Qsci))
    EOS
    pythons.each do |python, version|
      unless Formula[python].installed?
        ENV["PYTHONPATH"] = HOMEBREW_PREFIX/"lib/python#{version}/site-packages"
      end
      system python, "test.py"
    end
  end
end
