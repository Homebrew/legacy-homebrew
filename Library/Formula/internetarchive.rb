require "utils/json"

class Internetarchive < Formula
  desc "A Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/ia-wrapper"
  url "https://pypi.python.org/packages/source/i/internetarchive/internetarchive-0.7.9.tar.gz"
  sha1 "f52fd6cdece11da62bb8b32664da9271be3eaa91"

  bottle do
    cellar :any
    sha1 "3e2652bc8bb090c55c58465fe3d89112e65f9f9f" => :yosemite
    sha1 "d6d08b15f7e8a3ab9c1dc79494dec4278cd823c9" => :mavericks
    sha1 "996ccdd1ee9ec8b5adf4b16063f1f02b2b03ba63" => :mountain_lion
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha1 "476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73"
  end

  resource "args" do
    url "https://pypi.python.org/packages/source/a/args/args-0.1.0.tar.gz"
    sha1 "2fcab65fb504d33aa146a454f54c6768b5e9175a"
  end

  resource "clint" do
    url "https://pypi.python.org/packages/source/c/clint/clint-0.3.3.tar.gz"
    sha1 "297f2967831cb6e1ad252d7c07a7a7a451c87624"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.4.1.tar.gz"
    sha1 "b4cfd03344390d73d84349c815808358a128cc1d"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.1.tar.gz"
    sha1 "3d0ad1cf495d2c801327042e02d67b4ee4b85cd4"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.3.0.tar.gz"
    sha1 "f57bc125d35ec01a81afe89f97dc75913a927e65"
  end

  resource "py" do
    url "https://pypi.python.org/packages/source/p/py/py-1.4.26.tar.gz"
    sha1 "5d9aaa67c1da2ded5f978aa13e03dfe780771fea"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.3.4.zip"
    sha1 "4e5715657d845f9cd6fc30cf8bae037b24ebc715"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-0.4.tar.gz"
    sha1 "a0c993a3b38e26cda14c5d472a89fd007a515afc"
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
