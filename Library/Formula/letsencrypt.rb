class Letsencrypt < Formula
  desc "The Let's Encrypt Client is a tool to automatically receive and install X.509 certificates"
  homepage "https://letsencrypt.org/"
  head "https://github.com/letsencrypt/letsencrypt.git", :using => :git
  url "https://github.com/letsencrypt/letsencrypt.git", :revision => "d55c3e", :using => :git
  version "0.1"
  sha256 "e93d298cc6364f833ac77bb85f349b35cb7c01febdf4be4a17198f4eb744d24e"

  resource "virtualenv" do
    url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz"
    sha256 "aabc8ef18cddbd8a2a9c7f92bc43e2fea54b1147330d65db920ef3ce9812e3dc"
  end

  depends_on "augeas"
  depends_on "dialog"
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
end
