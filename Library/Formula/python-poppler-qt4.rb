require 'formula'

class PythonPopplerQt4 < Formula
  homepage 'https://code.google.com/p/python-poppler-qt4/'
  url 'https://python-poppler-qt4.googlecode.com/files/python-poppler-qt4-0.16.3.tar.gz'
  sha1 'fe6aa650a1a917caeedd407ae0c428a5de9eefb8'

  depends_on :python2 => '2.6'
  depends_on 'sip'
  depends_on 'poppler' => 'with-qt4'
  depends_on 'qt'
  depends_on 'pyqt'

  def install
    python do
      append_path 'PATH', File.join(HOMEBREW_PREFIX, 'bin')
      system python, "setup.py", "build"
      system python, "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"
    end
  end

  test do
    python do
      system python, '-c', 'import popplerqt4'
    end
  end

  private

  def append_path(path)
    ENV['PATH'] = [ENV['PATH'], path].compact.join ':'
  end
end
