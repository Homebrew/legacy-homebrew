class Letsencrypt < Formula
  desc "Tool to automatically receive and install X.509 certificates"
  homepage "https://letsencrypt.org/"
  url "https://github.com/letsencrypt/letsencrypt.git", :tag => "v0.0.0.dev20151020", :revision => "eefa106ff45fd3c20c18c5585b6552bea6f58087"
  version "0.0.0.dev20151020"
  head "https://github.com/letsencrypt/letsencrypt.git"

  resource "virtualenv" do
    url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz"
    sha256 "aabc8ef18cddbd8a2a9c7f92bc43e2fea54b1147330d65db920ef3ce9812e3dc"
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    resource("virtualenv").stage { system "python2.7", *Language::Python.setup_install_args(buildpath/"vendor") }

    ENV["PYTHONPATH"] = buildpath/"vendor/lib/python2.7/site-packages"
    system "./vendor/bin/virtualenv",
           "--no-site-packages",
           "-p", "python2.7",
           prefix/"venv"

    system prefix/"venv/bin/pip",
           "install",
           "-r", "requirements.txt",
           "acme/",
           ".",
           "letsencrypt-apache/",
           "letsencrypt-nginx/"

    bin.install_symlink prefix/"venv/bin/letsencrypt"
  end

  test do
    require "open3"

    cmd = "#{bin}/letsencrypt --version"

    Open3.popen3(cmd) do |_stdin, _stdout, stderr|
      installed_version = stderr.read
      assert_equal("letsencrypt 0.0.0.dev20151020\n", installed_version)
    end
  end
end
