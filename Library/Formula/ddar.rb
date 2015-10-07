class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar/wiki"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 1

  head "https://github.com/basak/ddar.git"

  depends_on "xmltoman" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_path "PYTHONPATH", Language::Python.homebrew_site_packages

    system "make", "-f", "Makefile.prep", "pydist"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir["*.1"]
  end

  test do
    # WIP don't merge this
    system "ddar", "-h"
  end
end
