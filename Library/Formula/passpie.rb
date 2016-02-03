class Passpie < Formula
  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://pypi.python.org/packages/source/p/passpie/passpie-1.3.1.tar.gz"
  sha256 "90106e09b1d2609bcf6476157cafd42cfd639cd718a26a55674d87ccb9303b29"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb97d90f195935368be486424f8e19165d64c2aed5497d9c51c34e860eb82dd8" => :el_capitan
    sha256 "916f2da581e3575a31ec9d6b8c533a2b6351756d537ef19651769d256b7c069d" => :yosemite
    sha256 "588af60dec0c750c393e4c5eeac0913fe712a3fc02ea9b569bb05990536e0d56" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :gpg

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.2.tar.gz"
    sha256 "fba0ff70f5ebb4cebbf64c40a8fbc222fb7cf825237241e548354dabe3da6a82"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "rstr" do
    url "https://pypi.python.org/packages/source/r/rstr/rstr-2.2.3.tar.gz"
    sha256 "10a58eb08a7e3735eddc8f32f3db419797dadb6335b02b94dcd8d741363d79e9"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "tinydb" do
    url "https://pypi.python.org/packages/source/t/tinydb/tinydb-3.1.2.zip"
    sha256 "6d9df6c30fc37dad487c23bfadfa6161de422a7f2b16b55d779df88559fc9095"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[click rstr tabulate tinydb PyYAML].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"passpie", "-D", "passpiedb", "init", "--force", "--passphrase", "s3cr3t"
  end
end
