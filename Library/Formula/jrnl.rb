require "formula"

class Jrnl < Formula
  homepage "http://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.7.tar.gz"
  sha1 "65914c66762ded186201a526b19e702dd35b0939"

  bottle do
    cellar :any
    sha1 "85aeed5404abd7a962fe30cb68151f461e944070" => :yosemite
    sha1 "cec814646e140a72c994c9e7a55a4428a6b7e336" => :mavericks
    sha1 "127d73c4f50620bfab34bd398102c8f9f1821f12" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.tar.gz"
    sha1 "c17e41a80b3fbf2ee4e8f2d8bb9e28c5d08bbb84"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-4.0.zip"
    sha1 "45d6d052dda9ba5ed072e29abf88b1b473cb38c4"
  end

  resource "parsedatetime" do
    url "https://pypi.python.org/packages/source/p/parsedatetime/parsedatetime-1.4.tar.gz"
    sha1 "4b9189d38f819cc8144f30d91779716a696d97f8"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-1.5.tar.gz"
    sha1 "28dec6c6361dd12805dc8e8887cd7da7e3348f39"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.7.tar.bz2"
    sha1 "93f461ed9e3fb0e42becf8d7f09647daafc54d66"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  resource "tzlocal" do
    url "https://pypi.python.org/packages/source/t/tzlocal/tzlocal-1.1.1.zip"
    sha1 "6f3d6d1fc5a7dcdd41d5be22ab90351be4a6ed47"
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
