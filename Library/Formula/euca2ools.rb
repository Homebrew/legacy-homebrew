require "formula"

class Euca2ools < Formula
  homepage "https://github.com/eucalyptus/euca2ools"
  url "https://github.com/eucalyptus/euca2ools/archive/v3.1.0.tar.gz"
  sha1 "5290172546707f3729da314535a7a9a429edda24"
  head "https://github.com/eucalyptus/euca2ools.git", :branch => "master"

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
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-4.0.tar.gz"
    sha1 "ff9212d50573ea9983d81d53bd11e834cf863b25"
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
    install_args = ["setup.py", "install", "--prefix=#{libexec}"]

    resource("requestbuilder").stage { system "python", *install_args }
    resource("requests").stage { system "python", *install_args }
    resource("setuptools").stage { system "python", *install_args }
    resource("lxml").stage { system "python", *install_args }
    resource("six").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt",
           "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/euca-describe-instances", "--help"
  end
end
