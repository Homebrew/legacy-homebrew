require "formula"

class Frescobaldi < Formula
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.0.16/frescobaldi-2.0.16.tar.gz"
  sha1 "6b7e72def3f93aa9521d7a1cdb72399f1a5765c5"

  option "without-launcher", "Don't build Mac .app launcher"
  option "without-lilypond", "Don't install Lilypond"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "portmidi" => :recommended
  depends_on "lilypond" => :recommended

  # python-poppler-qt4 dependencies
  depends_on "poppler" => "with-qt"
  depends_on "pyqt"
  depends_on "pkg-config" => :build

  resource "python-poppler-qt4" do
    url "https://github.com/wbsoft/python-poppler-qt4/archive/v0.18.1.tar.gz"
    sha1 "584345ae2fae2e1d667222cafa404a241cf95a1f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("python-poppler-qt4").stage do
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
end
