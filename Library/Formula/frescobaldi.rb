require "formula"

class Frescobaldi < Formula
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.18/frescobaldi-2.18.tar.gz"
  sha256 "6531a6425a0b0a471fb0845098e9c890e59d6379636ed79b4512a48599327d4b"

  option "without-launcher", "Don't build Mac .app launcher"
  option "without-lilypond", "Don't install Lilypond"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "portmidi" => :optional
  depends_on "lilypond" => :optional

  # python-poppler-qt4 dependencies
  depends_on "poppler" => "with-qt"
  depends_on "pyqt"
  depends_on "pkg-config" => :build

  resource "python-poppler-qt4" do
    url "https://github.com/wbsoft/python-poppler-qt4/archive/v0.18.1.tar.gz"
    sha1 "584345ae2fae2e1d667222cafa404a241cf95a1f"
  end

  resource "python-ly" do
    url "https://pypi.python.org/packages/source/p/python-ly/python-ly-0.9.1.tar.gz"
    sha1 "0c9eaab04484c99eeab645a66c19ab499afb2c1d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("python-poppler-qt4").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end
    resource("python-ly").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    rm "setup.cfg"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    if build.with? "launcher"
      system "python", "macosx/mac-app.py", "--force", "--version",  version, "--script", libexec/"bin/frescobaldi"
      inreplace "dist/Frescobaldi.app/Contents/Resources/__boot__.py",
                "_path_inject(['#{libexec}/bin'])",
                "_path_inject(['#{libexec}/bin', '#{libexec}/lib/python2.7/site-packages', '#{libexec}/vendor/lib/python2.7/site-packages'])"
      prefix.install "dist/Frescobaldi.app"
    end
  end

  test do
    system bin/"frescobaldi", "--version"
  end

  def caveats
    s = <<-EOS.undent
      By default, a splash screen is shown on startup; this causes the main
      window not to show until the application icon on the dock is clicked
      (Cmd-Tab application switching does not appear to work). You may
      want to disable the splash screen in the preferences to solve this
      issue. See:
        https://github.com/wbsoft/frescobaldi/issues/428
    EOS
    return s
  end
end
