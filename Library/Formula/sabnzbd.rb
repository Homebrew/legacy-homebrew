require "formula"

class Sabnzbd < Formula
  homepage "http://sabnzbd.org"
  url "http://downloads.sourceforge.net/sabnzbdplus/SABnzbd-0.7.18-src.tar.gz"
  sha256 "aa05697d901b3e334e92f274b2e8788973059840be656a1545e8f2a4b070b014"

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.1.tar.gz"
    sha1 "2c9cedad000e9ecdf0b220bd1ad46bc4592d067e"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha1 "c218f5d8bc97b39497680f6be9b7bd093f696e89"
  end

  depends_on "unrar"
  depends_on "par2"

  def install
    prefix.install_metafiles
    libexec.install Dir["*"]

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource("Markdown").stage { system "python", *install_args }
    resource("Cheetah").stage { system "python", *install_args }

    (bin+"sabnzbd").write(startup_script)
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/SABnzbd.py" "$@"
    EOS
  end
end
