require "formula"

class Jrnl < Formula
  homepage "http://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.6.tar.gz"
  sha1 "925571cd9ba85803a291d0a0816dbf79882e45dd"
  revision 1

  bottle do
    cellar :any
    sha1 "68111b2f2070623dfa91869989843018faa5244c" => :mavericks
    sha1 "98e6b91c9f935129ba55f6a912eb7bf1fec9fcb6" => :mountain_lion
    sha1 "33ed611db67d3be6f827a4a707db7697a0597cd4" => :lion
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
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.2.tar.gz"
    sha1 "fbafcd19ea0082b3ecb17695b4cb46070181699f"
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
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    %w[pycrypto keyring parsedatetime python-dateutil pytz six tzlocal].each do |r|
        resource(r).stage do
            system "python", "setup.py", "install", "--prefix=#{libexec}"
        end
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
           "--single-version-externally-managed", "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/jrnl", "-v"
    assert_equal 0, $?.exitstatus
  end
end
