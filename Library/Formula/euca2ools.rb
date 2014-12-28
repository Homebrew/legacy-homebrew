class Euca2ools < Formula
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://github.com/eucalyptus/euca2ools/archive/v3.1.1.tar.gz"
  sha1 "a29646fe312ae90c625304a9b969f5ab8bec44d8"
  head "https://github.com/eucalyptus/euca2ools.git"

  bottle do
    cellar :any
    sha1 "e5937cd5b80eb378a375f8488d20063583325e04" => :yosemite
    sha1 "6b648aed9dbc3b7cafafba8dafc7dc90d875e0cd" => :mavericks
    sha1 "3f9f60ed9faddc376adffe09ae8e3fdd35836bcf" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requestbuilder" do
    url "https://github.com/boto/requestbuilder/archive/v0.2.1.tar.gz"
    sha1 "7c9b67293550959c5cd20513ae276727fa224e17"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.3.0.tar.gz"
    sha1 "f57bc125d35ec01a81afe89f97dc75913a927e65"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-5.2.tar.gz"
    sha1 "749f1ea153426866d6117d00256cf37c90b1b4f5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.7.2.tar.gz"
    sha1 "6ed970106d18e48b361b09c227dac83b4cc72f26"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.3.5.tar.gz"
    sha1 "7a6e92f8ca482aab79835e1c9cd8410400792cd9"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt",
           "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/euca-version"
    system "#{bin}/euca-describe-instances", "--help"
  end
end
