require "formula"

class Jrnl < Formula
  homepage "http://maebert.github.io/jrnl/"
  url "https://github.com/maebert/jrnl/archive/1.9.6.tar.gz"
  sha1 "925571cd9ba85803a291d0a0816dbf79882e45dd"
  revision 2

  bottle do
    cellar :any
    sha1 "4065ac663f692810f854256bbee38e9611bb193f" => :mavericks
    sha1 "da02ddf49d31cbfe264b51162328db5c6c38f68e" => :mountain_lion
    sha1 "b518ad8634355a28662b7ddd0bad390615cf091d" => :lion
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
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    %w[six pycrypto keyring parsedatetime python-dateutil pytz tzlocal].each do |r|
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
