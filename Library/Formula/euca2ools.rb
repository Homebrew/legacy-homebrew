class Euca2ools < Formula
  desc "Eucalyptus client API tools-works with Amazon EC2 and IAM"
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://github.com/eucalyptus/euca2ools/archive/v3.2.0.tar.gz"
  sha256 "4cfbae3b978312fa23e6a0329ec346568823afbbae0bc01075c8cff6707e7cb8"
  head "https://github.com/eucalyptus/euca2ools.git"

  bottle do
    cellar :any
    sha256 "e6bafd8e267f6c685546518aec24fb3fd42d38fdea9c0afffdb89a99a9b8a9e6" => :yosemite
    sha256 "1b8b1f2d726a702bd726e231cae76b4304fed808e6052464ab54aa8040c9804b" => :mavericks
    sha256 "05983e41263f7796f8fab91e9d9099ec604cb964fea0452aa77ef3bbeb4dac4b" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requestbuilder" do
    url "https://github.com/boto/requestbuilder/archive/v0.2.3.tar.gz"
    sha256 "37991003f838847b9bfe041d08383964f8da5f5027656f631fafc3099c6ef4c9"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz"
    sha256 "718d13adf87f99a45835bb20e0a1c4c036de644cd32b3f112639403aa04ebeb5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.2.tar.gz"
    sha256 "c7d5990298af6ffb00312973a25f0cc917a6368126dd40eaab41d78d3e1ea25d"
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
