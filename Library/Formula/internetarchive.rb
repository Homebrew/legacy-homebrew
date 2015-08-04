require "utils/json"

class Internetarchive < Formula
  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/ia-wrapper"
  url "https://pypi.python.org/packages/source/i/internetarchive/internetarchive-0.7.9.tar.gz"
  sha256 "4976c8c0b60289e6abe0a893df35403038692df7704ebbf11fddb6590324dd03"

  bottle do
    cellar :any
    sha1 "3e2652bc8bb090c55c58465fe3d89112e65f9f9f" => :yosemite
    sha1 "d6d08b15f7e8a3ab9c1dc79494dec4278cd823c9" => :mavericks
    sha1 "996ccdd1ee9ec8b5adf4b16063f1f02b2b03ba63" => :mountain_lion
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha256 "e713da45c96ca53a3a8b48140d4120374db622df16ab71759c9ceb5b8d46fe7c"
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
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.1.tar.gz"
    sha256 "71ad940a773fbc23be6093e9476ad57b2ecec446946a28d30127501f3b29aa35"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.3.0.tar.gz"
    sha256 "1c1473875d846fe563d70868acf05b1953a4472f4695b7b3566d1d978957b8fc"
  end

  resource "py" do
    url "https://pypi.python.org/packages/source/p/py/py-1.4.26.tar.gz"
    sha256 "28dd0b90d29b386afb552efc4e355c889f4639ce93658a7872a2150ece28bb89"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.3.4.zip"
    sha256 "5616f744a311c5f5fbb44943aaa41c32df70ba132159a0a9fb6c999060d7645c"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-0.4.tar.gz"
    sha256 "43d725fb21d31740b4af177d482d9ae53fe23daccb13b2b7da2113fe80b3191e"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[PyYAML args clint six docopt requests py pytest jsonpatch].each do |r|
      resource(r).stage do
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
