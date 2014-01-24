require "formula"

class Frescobaldi < Formula
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.0.13/frescobaldi-2.0.13.tar.gz"
  sha1 "8d3f0ceb0d5cc66b6bee6278fc2dad07e3f361f8"

  option "without-launcher", "Don't build Mac .app launcher"
  option "without-lilypond", "Don't install Lilypond"

  depends_on :python
  depends_on "portmidi" => :recommended
  depends_on "lilypond" => :recommended
  depends_on "platypus" => :build if build.with? "launcher"

  # python-poppler-qt4 dependencies
  depends_on "poppler" => "with-qt4"
  depends_on "pyqt"
  depends_on "pkg-config" => :build

  resource "python-poppler-qt4" do
    url "https://python-poppler-qt4.googlecode.com/files/python-poppler-qt4-0.16.3.tar.gz"
    sha1 "fe6aa650a1a917caeedd407ae0c428a5de9eefb8"
  end

  def install
    resource("python-poppler-qt4").stage do
      system "python", "setup.py", "build"
      system "python", "setup.py", "install"
    end
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    if build.with? "launcher"
      system "platypus", "-aFrescobaldi", "-oNone",
             bin/"frescobaldi", bin/"Frescobaldi.app"
    end
  end
end
