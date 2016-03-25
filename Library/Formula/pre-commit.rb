class PreCommit < Formula
  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.7.6.tar.gz"
  sha256 "817e794d62189e649f219491ca529f2208b3e331d06eddb1b4c4118e580c1235"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdc345075a911bbb5cc57c28430875d0f62be10d506e4fffa58b3670f19014bc" => :el_capitan
    sha256 "b6ff194988cab87c37b384e7c58af0b18e0e4e12f6dc7cb00ff747ae23cd99be" => :yosemite
    sha256 "87a38186329e7e659c61779eb03b03d194293b9c13da7f19a2d24aa4cde5cfe5" => :mavericks
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

  resource "virtualenv" do
    url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-14.0.6.tar.gz"
    sha256 "1ffb6a02d8999e9c97ad8f04b1d2ba44421dfb8f8a98b54aea5c6fdfb53bc526"
  end

  resource "functools32" do
    url "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
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
