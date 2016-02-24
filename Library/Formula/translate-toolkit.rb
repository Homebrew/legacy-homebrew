class TranslateToolkit < Formula
  desc "Toolkit for localization engineers"
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/1.12.0/translate-toolkit-1.12.0.tar.bz2"
  sha256 "11e332f2a29d8644364b4ca79b4ac079df328626ec8c27ac0e8cc454696719ca"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any
    revision 1
    sha256 "ee17dc35e2f0f862ac5c011f9cd0cd0022f7a4c62de0353e20eeaf9480006f49" => :yosemite
    sha256 "ae6ed22058dfd558efa42f5779f97b05fd5575bb3cfd06dff61e60c49f374337" => :mavericks
    sha256 "31459fd05ccb213ded2ff0c048e25590913778211c9eda9b980ba8248150baaa" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-2.0.tar.gz"
    sha256 "062e6dbebcbe738eaa6e6298fe38b1ddf355dbe67a9f76c67a79fcef67468c5b"
  end

  resource "pylev" do
    url "https://pypi.python.org/packages/source/p/python-Levenshtein/python-Levenshtein-0.10.2.tar.gz"
    sha256 "49a3b3c3210157e2070eb46c0713e64f409efc8c9a7520632ddf16f8a9508bed"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha256 "047bbbba41bac37c444c75ddfdf0573dd6e2f1fbd824e6247bb26fa7d8fa3830"
  end

  resource "diffmatch" do
    url "https://pypi.python.org/packages/source/d/diff-match-patch/diff-match-patch-20121119.tar.gz"
    sha256 "9dba5611fbf27893347349fd51cc1911cb403682a7163373adacc565d11e2e4c"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz"
    sha256 "a2b29bd048ca2fe54a046b29770964738872a9747003a371344a93eedf7ad58e"
  end

  resource "iniparse" do
    url "https://pypi.python.org/packages/source/i/iniparse/iniparse-0.3.1.tar.gz"
    sha256 "b6b31f6c920af95168bb29e68b45c284ebf2c9928b87a509312cf5cf7215fb20"
  end

  resource "vobject" do
    url "https://pypi.python.org/packages/source/v/vobject/vobject-0.6.6.tar.gz"
    sha256 "99c02897946257bd036acbbf37888cf5e7ecb832f98d68cbf9c6e8b4a591bd86"
  end

  resource "cherrypy" do
    url "https://pypi.python.org/packages/source/C/CherryPy/CherryPy-3.2.4.tar.gz"
    sha256 "abd73a449936740e99d3a05eb89b9381dc188ef696904f585463bc28079f1288"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.2.0.zip"
    sha256 "3ab48f714edc7e72525caf370f239b46e493d9dec229384ecb52f9135932506d"
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
