class Jrnl < Formula
  desc "Command-line note taker"
  homepage "https://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.7.tar.gz"
  sha256 "789de4bffe0c22911a4968e525feeb20a6c7c4f4fe762a936ce2dac2213cd855"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5f24dc1ba2c58e7a9cebd7ae0492be6fbab0c05c3fa96e2f7cf9f9e9513bfd5" => :el_capitan
    sha256 "0b3c9aa68cb0030d466a7791bf20efba2969ba1884f04a96c51503f2e13fb62b" => :yosemite
    sha256 "85b7ad5b70623523729e5211581e5fc3b096b6dff8d6828781df4133f6b9a545" => :mavericks
    sha256 "b4e68781cff4b60490c309a26e66b60860dd0b3b87e580e8d93c0930cd5481c7" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz"
    sha256 "7293c9d7e8af2e44a82f86eb9c3b058880f4bcc884bf3ad6c8a34b64986edde8"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-4.0.zip"
    sha256 "ea93c3cd9666c648263df4daadc5f34aeb27415dbf8e4d76579a8a737f1741cf"
  end

  resource "parsedatetime" do
    url "https://pypi.python.org/packages/source/p/parsedatetime/parsedatetime-1.4.tar.gz"
    sha256 "09bfcd8f3c239c75e77b3ff05d782ab2c1aed0892f250ce2adf948d4308fe9dc"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-1.5.tar.gz"
    sha256 "6f197348b46fb8cdf9f3fcfc2a7d5a97da95db3e2e8667cf657216274fe1b009"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.7.tar.bz2"
    sha256 "56dec1e94d2fad13d9009a140b816808086a79ddf7edf9eb4931c84f65abb12a"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha256 "047bbbba41bac37c444c75ddfdf0573dd6e2f1fbd824e6247bb26fa7d8fa3830"
  end

  resource "tzlocal" do
    url "https://pypi.python.org/packages/source/t/tzlocal/tzlocal-1.1.1.zip"
    sha256 "696bfd8d7c888de039af6c6fdf86fd52e32508277d89c75d200eb2c150487ed4"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[six pycrypto keyring parsedatetime python-dateutil pytz tzlocal].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/jrnl", "-v"
  end
end
