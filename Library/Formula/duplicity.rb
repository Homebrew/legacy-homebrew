require "formula"

class Duplicity < Formula
  homepage "http://www.nongnu.org/duplicity/"
  url "http://code.launchpad.net/duplicity/0.6-series/0.6.24/+download/duplicity-0.6.24.tar.gz"
  sha1 "1d0bab80cb9465080179307d969e292c7145c714"

  bottle do
    cellar :any
    sha1 "dda9a29d50ff2a600dcf09d464508c2f73dcadc3" => :mavericks
    sha1 "bb80b982fe70b9ef9376808ae232c4e2a010bf56" => :mountain_lion
    sha1 "e0834d616e404ce6fb6605b8a9524d329b8bce6a" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "gnupg"

  option :universal

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.9.1.tar.gz"
    sha1 "9870cc7e7d4b23f0b6c39cf6ba597c87871ac6de"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.14.0.tar.gz"
    sha1 "54a34873b09c3dd3ea7090caa914908b3e0f1822"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.32.0.tar.gz"
    sha1 "3600168823a0c37051daf24c5147e1a9ae73d28d"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"

    ENV.universal_binary if build.universal?

    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    resource("lockfile").stage { system "python", *install_args }
    resource("paramiko").stage { system "python", *install_args }
    resource("boto").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"duplicity", "--version"
  end
end
