require "utils/json"

class Internetarchive < Formula
  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://pypi.python.org/packages/source/i/internetarchive/internetarchive-0.8.5.tar.gz"
  sha256 "2ba5e8db802953b1ac25a73c88d0955df2e4cd947bc664d94d6000003b91f14e"

  bottle do
    cellar :any
    sha256 "9b7d0ec74c77c7e8d64f496199c83c9a6b5b986ae4292d073d09fd9dd3b3cee3" => :yosemite
    sha256 "a76cbf8fb2b26b66aec9d107c8cad3546143f084c78b3fe30f9ea77db98611b8" => :mavericks
    sha256 "e31e96459aa0c732fa2b39778c863ca2ea1935f36e74548fe93499304cc0ca9a" => :mountain_lion
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
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "py" do
    url "https://pypi.python.org/packages/source/p/py/py-1.4.30.tar.gz"
    sha256 "b703e57685ed7c280b1a51c496a4984d83d89def2a930b5e9e5da5a6ca151514"
  end

  resource "pytest" do
    url "https://pypi.python.org/packages/source/p/pytest/pytest-2.3.4.zip"
    sha256 "5616f744a311c5f5fbb44943aaa41c32df70ba132159a0a9fb6c999060d7645c"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-0.4.tar.gz"
    sha256 "43d725fb21d31740b4af177d482d9ae53fe23daccb13b2b7da2113fe80b3191e"
  end

  resource "cython" do
    url "https://pypi.python.org/packages/source/C/Cython/Cython-0.23.tar.gz"
    sha256 "9fd01e8301c24fb3ba0411ad8eb16f5d9f9f8e66b1281fbe7aba2a9bd9d343dc"
  end

  resource "greenlet" do
    url "https://pypi.python.org/packages/source/g/greenlet/greenlet-0.4.7.zip"
    sha256 "f32c4fa4e06443e1bdb0d32b69e7617c25ff772c3ffc6d0aa63d192e9fd795fe"
  end

  # For "speedups": https://pypi.python.org/pypi/internetarchive, Installation
  resource "ujson" do
    url "https://pypi.python.org/packages/source/u/ujson/ujson-1.33.zip"
    sha256 "68cf825f227c82e1ac61e423cfcad923ff734c27b5bdd7174495d162c42c602b"
  end

  # For "speedups": https://pypi.python.org/pypi/internetarchive, Installation
  resource "gevent" do
    url "https://pypi.python.org/packages/source/g/gevent/gevent-1.0.2.tar.gz"
    sha256 "3ae1ca0f533ddcb17aab16ce66b424b3f3b855ff3b9508526915d3c6b73fba31"
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
