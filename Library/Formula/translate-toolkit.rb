require "formula"

class TranslateToolkit < Formula
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/1.12.0/translate-toolkit-1.12.0.tar.bz2"
  sha1 "76d3f33afb5ac723da05558cebe80642af31657a"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any
    revision 1
    sha1 "b06dbd6f29d109d1afe8854ea4e3256a0305c775" => :yosemite
    sha1 "a2642c64d692c38b057be500196fcfaad76c69fb" => :mavericks
    sha1 "5b36a52a091ee936ed0ed414cd86879f742827d0" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-2.0.tar.gz"
    sha1 "70f1279ea5cc896090b5f8068d0d0199b9aebfe1"
  end

  resource "pylev" do
    url "https://pypi.python.org/packages/source/p/python-Levenshtein/python-Levenshtein-0.10.2.tar.gz"
    sha1 "f0c55e615c3136e6b3c8d7b56917ecf48930edf8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  resource "diffmatch" do
    url "https://pypi.python.org/packages/source/d/diff-match-patch/diff-match-patch-20121119.tar.gz"
    sha1 "79a93dc622fd47fe30349b0be4a4c6e5ffc9bf67"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz"
    sha1 "8ff340de807ae5038bd4e6cc1b1e5b6c16d49ed0"
  end

  resource "iniparse" do
    url "https://pypi.python.org/packages/source/i/iniparse/iniparse-0.3.1.tar.gz"
    sha1 "932b980988ca8945586234308691b30b853bf0af"
  end

  resource "vobject" do
    url "https://pypi.python.org/packages/source/v/vobject/vobject-0.6.6.tar.gz"
    sha1 "1ed2003c368d0d3358dad139d4b9822c04ba5fea"
  end

  resource "cherrypy" do
    url "https://pypi.python.org/packages/source/C/CherryPy/CherryPy-3.2.4.tar.gz"
    sha1 "9a398e29e614c567d8dd0427ca28111b90df628f"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.2.0.zip"
    sha1 "0be66e9d07657b9580947d9f6c915d00b2d998e4"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    res = %w[six lxml pylev diffmatch beautifulsoup4 iniparse vobject cherrypy pytest]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install_data tries to install to /Library because translate-toolkit's
    # heuristic for extracting a relative site-packages path fails with Apple's
    # layout
    inreplace "setup.py", /^sitepackages =.+/, "sitepackages = 'lib/python2.7/site-packages'"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
