class Euca2ools < Formula
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://github.com/eucalyptus/euca2ools/archive/v3.1.1.tar.gz"
  sha1 "a29646fe312ae90c625304a9b969f5ab8bec44d8"
  head "https://github.com/eucalyptus/euca2ools.git"
  revision 1

  bottle do
    cellar :any
    sha256 "aaf36db21152a51b950a3340b6953df9a4eb519aea4e8a3ccf0349f1c74048c6" => :yosemite
    sha256 "8de77b16d023d0ea9402084496715326c2612b8aa1dd3536bb57d20f482396a2" => :mavericks
    sha256 "ab28eede249916d514b302320efdd4cceac73a6dac60e9354dc6ff4a8f8343e6" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requestbuilder" do
    url "https://github.com/boto/requestbuilder/archive/v0.2.1.tar.gz"
    sha1 "7c9b67293550959c5cd20513ae276727fa224e17"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
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
