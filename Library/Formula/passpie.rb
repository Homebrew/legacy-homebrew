class Passpie < Formula
  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://pypi.python.org/packages/source/p/passpie/passpie-1.3.1.tar.gz"
  sha256 "90106e09b1d2609bcf6476157cafd42cfd639cd718a26a55674d87ccb9303b29"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b157ec8e0eefab1497935fa33ea234c10130c52ef9992ad6a16afde4f1ac43b9" => :el_capitan
    sha256 "412da32cbf45e87d66dce6be9641dac0d81c30907f7c05e076839598882e55e8" => :yosemite
    sha256 "78bab7bb5024e60a247f65a50e92d9f7916fa4ceb988a301090c6eacd91a87e2" => :mavericks
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
