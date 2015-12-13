require "utils/json"

class Internetarchive < Formula
  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://pypi.python.org/packages/source/i/internetarchive/internetarchive-0.9.8.tar.gz"
  sha256 "d89a0e04ea99e65ead8f5a00114c807e0d75108b76eaf34be4abd9f0c41bf73e"

  bottle do
    cellar :any
    sha256 "9b7d0ec74c77c7e8d64f496199c83c9a6b5b986ae4292d073d09fd9dd3b3cee3" => :yosemite
    sha256 "a76cbf8fb2b26b66aec9d107c8cad3546143f084c78b3fe30f9ea77db98611b8" => :mavericks
    sha256 "e31e96459aa0c732fa2b39778c863ca2ea1935f36e74548fe93499304cc0ca9a" => :mountain_lion
  end

  depends_on "libyaml"

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "args" do
    url "https://pypi.python.org/packages/source/a/args/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://pypi.python.org/packages/source/c/clint/clint-0.3.3.tar.gz"
    sha256 "84fbf297d8ca26fa6bb427de699f0dfcf874d66702c50834d187f99f03b46265"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.4.1.tar.gz"
    sha256 "f045afd6dffb755cc0411acb7ce9acc4de0e71261d4b5f91de2e68d9aa5f8367"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "py" do
    url "https://pypi.python.org/packages/source/p/py/py-1.4.31.tar.gz"
    sha256 "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.8.5.zip"
    sha256 "44bb32fb3925b5a284ceee1af55e0a63d25436ec415232089403eed3a347667e"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-0.4.tar.gz"
    sha256 "43d725fb21d31740b4af177d482d9ae53fe23daccb13b2b7da2113fe80b3191e"
  end

  resource "ujson" do
    url "https://pypi.python.org/packages/source/u/ujson/ujson-1.34.tar.gz"
    sha256 "3d09807685ecf2eed3b68985aca4f7ad619eadfae9054d1e23a20c54ea861102"
  end

  resource "Cython" do
    url "https://pypi.python.org/packages/source/C/Cython/Cython-0.23.4.tar.gz"
    sha256 "fec42fecee35d6cc02887f1eef4e4952c97402ed2800bfe41bbd9ed1a0730d8e"
  end

  resource "greenlet" do
    url "https://pypi.python.org/packages/source/g/greenlet/greenlet-0.4.9.tar.gz"
    sha256 "79f9b8bbbb1c599c66aed5e643e8b53bae697cae46e0acfc4ee461df48a90012"
  end

  resource "gevent" do
    url "https://pypi.python.org/packages/source/g/gevent/gevent-1.0.tar.gz"
    sha256 "bfa9d846db91a7d8b6a36e87353eed641c7e3e7d0bfa0b9975796d227f2db4eb"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    metadata = Utils::JSON.load shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end
