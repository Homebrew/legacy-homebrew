require "utils/json"

class Internetarchive < Formula
  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://pypi.python.org/packages/source/i/internetarchive/internetarchive-1.0.2.tar.gz"
  sha256 "a0c90218950d894d7549d3af6c2f6adf5915c72dc2213ff74a90f25ab1598ad9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a5d623940b0d930ca573f864ff56ef676df8c8f466f62a1faacc14039ccb7e3" => :el_capitan
    sha256 "51ec33b894735303bcf2f3223815eeb763e5420f08e11a5dad6aec9818560956" => :yosemite
    sha256 "905133146b5145deb2af74d47dc19737580e9ab870a76d0f6f919a1d861d894b" => :mavericks
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "args" do
    url "https://pypi.python.org/packages/source/a/args/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://pypi.python.org/packages/source/c/clint/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "py" do
    url "https://pypi.python.org/packages/source/p/py/py-1.4.31.tar.gz"
    sha256 "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.9.0.tar.gz"
    sha256 "6fad53ccbf0903c69db93d67b83df520818b06c7597ed8a8407bc5fdffd5e40e"
  end

  resource "ujson" do
    url "https://pypi.python.org/packages/source/u/ujson/ujson-1.35.tar.gz"
    sha256 "f66073e5506e91d204ab0c614a148d5aa938bdbf104751be66f8ad7a222f5f86"
  end

  resource "Cython" do
    url "https://pypi.python.org/packages/source/C/Cython/Cython-0.23.4.tar.gz"
    sha256 "fec42fecee35d6cc02887f1eef4e4952c97402ed2800bfe41bbd9ed1a0730d8e"
  end

  resource "greenlet" do
    url "https://pypi.python.org/packages/source/g/greenlet/greenlet-0.4.9.tar.gz"
    sha256 "79f9b8bbbb1c599c66aed5e643e8b53bae697cae46e0acfc4ee461df48a90012"
  end

  # For "speedups": https://pypi.python.org/pypi/internetarchive, Installation

  resource "ujson" do
    url "https://pypi.python.org/packages/source/u/ujson/ujson-1.34.tar.gz"
    sha256 "3d09807685ecf2eed3b68985aca4f7ad619eadfae9054d1e23a20c54ea861102"
  end

  resource "gevent" do
    url "https://pypi.python.org/packages/source/g/gevent/gevent-1.1.0.tar.gz"
    sha256 "34f7a5eca1326affe149eaa5467220d89002facd338028d2340868015407ae75"
  end

  resource "schema" do
    url "https://pypi.python.org/packages/source/s/schema/schema-0.4.0.tar.gz"
    sha256 "63f3ed23f3c383203bdac0c9a4c1fa823a507c3bfcd555954367a20a1c294973"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-0.4.tar.gz"
    sha256 "43d725fb21d31740b4af177d482d9ae53fe23daccb13b2b7da2113fe80b3191e"
  end

  def install
    # Required with Apple clang 7.0.0+/LLVM clang 3.6.0+ for gevent < 1.1.
    ENV.append "CFLAGS", "-std=gnu99" if ENV.compiler == :clang

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
