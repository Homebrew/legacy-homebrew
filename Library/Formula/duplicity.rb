require "formula"

class Duplicity < Formula
  homepage "http://www.nongnu.org/duplicity/"
  url "http://code.launchpad.net/duplicity/0.6-series/0.6.25/+download/duplicity-0.6.25.tar.gz"
  sha1 "fe0b6b0b0dc7dbc02598d96567954b48c4308420"

  bottle do
    revision 1
    sha1 "6813d6be6f1f651d42f7ee33e1c8939c47699d78" => :yosemite
    sha1 "84fe0d4e4502a2092c1838122c05f3beb2dd2288" => :mavericks
    sha1 "d787b1de4116f8c803d609cea27923f6b3d3bd37" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "gnupg"

  option :universal

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.32.0.tar.gz"
    sha1 "3600168823a0c37051daf24c5147e1a9ae73d28d"
  end

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.10.2.tar.gz"
    sha1 "1df8b1fad0c344230eaa7ce5fbf06521a74d7a6b"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.1.tar.gz"
    sha1 "1f2d48f6c1c5c8620c264a8b2a592a5383309fea"
  end

  resource "pycryptopp" do
    url "https://pypi.python.org/packages/source/p/pycryptopp/pycryptopp-0.6.0.1206569328141510525648634803928199668821045408958.tar.gz"
    sha1 "773008d41d5c135a5bd899cd4c4a51ee54a97e39"
  end

  resource "pyrax" do
    url "https://github.com/rackspace/pyrax/archive/v1.9.2.tar.gz"
    sha1 "4ff5a326c7cc83cc61d000c02acc6e4f116cc2d8"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    ENV.universal_binary if build.universal?

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    system bin/"duplicity", "--version"
  end
end
