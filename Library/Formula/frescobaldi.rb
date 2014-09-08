require "formula"

class Frescobaldi < Formula
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.0.15/frescobaldi-2.0.15.tar.gz"
  sha1 "e110ca2be338ca4fb9a0369c6f733dbdf731a027"

  option "without-launcher", "Don't build Mac .app launcher"
  option "without-lilypond", "Don't install Lilypond"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "portmidi" => :recommended
  depends_on "lilypond" => :recommended

  # python-poppler-qt4 dependencies
  depends_on "poppler" => "with-qt4"
  depends_on "pyqt"
  depends_on "pkg-config" => :build

  resource "python-poppler-qt4" do
    url "https://github.com/wbsoft/python-poppler-qt4/archive/v0.18.1.tar.gz"
    sha1 "584345ae2fae2e1d667222cafa404a241cf95a1f"
  end

  def install
    resource("python-poppler-qt4").stage do
      system "python", "setup.py", "build"
      system "python", "setup.py", "install"
    end
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    if build.with? "launcher"
      system "python", "macosx/mac-app.py", "--force", "--version",  version, "--script", bin/"frescobaldi"
      prefix.install "dist/Frescobaldi.app"
    end
  end
end
