class Euca2ools < Formula
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://github.com/eucalyptus/euca2ools/archive/v3.2.0.tar.gz"
  sha1 "f091b97d23dfb4c382899e32d4be71d531b36d21"
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
    url "https://github.com/boto/requestbuilder/archive/v0.2.3.tar.gz"
    sha1 "35c62097ae5b2a632fd387d239033e40c347a9ad"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz"
    sha1 "3c74c30dc08af9c759fc9622b01661ed61b55713"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.2.tar.gz"
    sha1 "7285670314e3f3327bfb06b3c11d794b823fad07"
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
