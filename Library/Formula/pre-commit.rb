class PreCommit < Formula
  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.6.2.tar.gz"
  sha256 "e659d79d7703442250e0a1795309f42578ac887e92bf33f69ff19da4cc00bb51"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c9b2f2f1c6fd451f007268dee19054f398887a77aebf6d91118b0bf4a371372" => :el_capitan
    sha256 "ddcd423efc7da2b205a018fdc19e9a3b4a977396eb9ef011a7920f88488f631b" => :yosemite
    sha256 "a32865409a696ce9f78982eec1eec97d19ec0ed6f35eea4c63fbdda163b7858e" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "aspy.yaml" do
    url "https://pypi.python.org/packages/source/a/aspy.yaml/aspy.yaml-0.2.1.tar.gz"
    sha256 "a91370183aea63c87d8487e7b399ed2d99a7c2f14b108d27c0bc8ad9ef595d9a"
  end

  resource "cached-property" do
    url "https://pypi.python.org/packages/source/c/cached-property/cached-property-1.2.0.tar.gz"
    sha256 "e3081a8182d3d4b7283eeade76c382bcfd4dfd644ca800598229c2ef798abb53"
  end

  resource "jsonschema" do
    url "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "nodeenv" do
    url "https://pypi.python.org/packages/source/n/nodeenv/nodeenv-0.13.6.tar.gz"
    sha256 "feaafb0486d776360ef939bd85ba34cff9b623013b13280d1e3770d381ee2b7f"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.1.tar.gz"
    sha256 "428ac8f3219c78fb04ce05895d5dff9bd813c05a9a7922c53dc879cd32a12493"
  end

  resource "virtualenv" do
    url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz"
    sha256 "aabc8ef18cddbd8a2a9c7f92bc43e2fea54b1147330d65db920ef3ce9812e3dc"
  end

  resource "functools32" do
    url "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "autopep8" do
    url "https://pypi.python.org/packages/source/a/autopep8/autopep8-1.2.1.tar.gz"
    sha256 "d0a7cdc397e46be0d91a968acb3f561cc1b9244f5df94a2514cf32acfc8a2e94"
  end

  resource "flake8" do
    url "https://pypi.python.org/packages/source/f/flake8/flake8-2.5.0.tar.gz"
    sha256 "8216c8c6ee092ae93d51f89bc91045648c88cd9be77d60cf47df7ca26ee4f88c"
  end

  resource "plumbum" do
    url "https://pypi.python.org/packages/source/p/plumbum/plumbum-1.6.0.tar.gz"
    sha256 "74c931a79d1c1851ee7a2d8b7f594c810930e46a6bdea7961e177d3670ed350e"
  end

  resource "pyflakes" do
    url "https://pypi.python.org/packages/source/p/pyflakes/pyflakes-1.0.0.tar.gz"
    sha256 "f39e33a4c03beead8774f005bd3ecf0c3f2f264fa0201de965fce0aff1d34263"
  end

  resource "pep8" do
    url "https://pypi.python.org/packages/source/p/pep8/pep8-1.6.2.tar.gz"
    sha256 "b8b7e35630b5539e26a197dfc6005be9e1e9a135496b377723a8ebc01b9bcbff"
  end

  resource "mccabe" do
    url "https://pypi.python.org/packages/source/m/mccabe/mccabe-0.3.1.tar.gz"
    sha256 "5f7ea6fb3aa9afe146d07fd6d5cedf788747d8b0c29e44732453c2b2db1e3d16"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # fix aspy.yaml (because namespace .pth isn't processed)
    touch libexec/"vendor/lib/python2.7/site-packages/aspy/__init__.py"

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<-EOF.undent
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: 5541a6a046b7a0feab73a21612ab5d94a6d3f6f0
          hooks:
          -   id: trailing-whitespace
      EOF
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
