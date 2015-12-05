class Frescobaldi < Formula
  desc "LilyPond sheet music text editor"
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.18.1/frescobaldi-2.18.1.tar.gz"
  sha256 "475bbb9aeed8009fdb7b0c53e4da78ce7a204b548d0af6d909b699c99e61d4c1"

  bottle do
    sha256 "2b11cbd21fef365684ec0be8543a557fbc943ce9832b5c2b7b5204a081de74aa" => :yosemite
    sha256 "c592d71f41e66f3f5115c8eac982344fa903eff02a7e3a011852a5ee3e39d968" => :mavericks
    sha256 "cc6e9b3a940690ae225a157f4a0d95aec4db46f0ccf78442a99ae941f7a358a0" => :mountain_lion
  end

  option "with-lilypond", "Install Lilypond from Homebrew/tex"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "portmidi" => :optional
  depends_on "homebrew/tex/lilypond" => :optional

  # python-poppler-qt4 dependencies
  depends_on "pkg-config" => :build
  depends_on "poppler" => "with-qt"
  depends_on "pyqt"

  resource "python-poppler-qt4" do
    url "https://github.com/wbsoft/python-poppler-qt4/archive/v0.18.1.tar.gz"
    sha256 "c6903c4b6ab71730ae2a1da9fb95830a83da82185b5ef6b8184b16c0cae908ba"
  end

  resource "python-ly" do
    url "https://pypi.python.org/packages/source/p/python-ly/python-ly-0.9.2.tar.gz"
    sha256 "a231b8f8977966afff70a840fb5baa1d3d263d5a9565ca9a5b28c398307952af"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[python-poppler-qt4 python-ly].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    rm "setup.cfg"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    By default, a splash screen is shown on startup; this causes the main
    window not to show until the application icon on the dock is clicked
    (Cmd-Tab application switching does not appear to work).

    You may want to disable the splash screen in the preferences to
    solve this issue. See:
      https://github.com/wbsoft/frescobaldi/issues/428
  EOS
  end

  test do
    system bin/"frescobaldi", "--version"
  end
end
