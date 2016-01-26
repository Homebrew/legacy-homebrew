class Passpie < Formula
  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://pypi.python.org/packages/source/p/passpie/passpie-1.0.2.tar.gz"
  sha256 "a1fda14f09116a390077741d767d76dd95bc6a7239dab206f08d2084c547436e"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any
    sha256 "f5ffd9c8c4b070b92ad3afdbf80dfc010d8727c566a39bcbdb75240e2e70e9bc" => :yosemite
    sha256 "e04a03cfdb64217b25dcca0b264b9300424927ea121bdef2f828a642961f9e2a" => :mavericks
    sha256 "ff7df4fa886c818b08c19175b1bbef4bca1d1dff32b5c6c8169340a10c97c292" => :mountain_lion
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
    url "https://pypi.python.org/packages/source/t/tinydb/tinydb-3.1.1.tar.gz"
    sha256 "b704d94b44c5dbc4f4b038f22aa30b4c7398a8d52881767b4e53edeaeab6d3d0"
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
    system bin/"passpie", "-D", "temp_db", "init", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "add", "foo@bar", "--random"
    system bin/"passpie", "-D", "temp_db", "add", "spam@egg", "--random"
    system bin/"passpie", "-D", "temp_db", "update", "foo@bar", "--comment", "'dummy comment'"
    system bin/"passpie", "-D", "temp_db", "export", "passwords.db", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "remove", "-y", "foo@bar"
    system bin/"passpie", "-D", "temp_db", "remove", "-y", "spam@egg"
    system bin/"passpie", "-D", "temp_db", "import", "passwords.db"
    system bin/"passpie", "-D", "temp_db", "copy", "foo@bar", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "init", "--force", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "add", "foo@bar", "--password", "'sup3r p4ssw0rd'"
    system bin/"passpie", "-D", "temp_db", "add", "foo@bar", "--force", "--random"
    system bin/"passpie", "-D", "temp_db", "add", "foo2@bar2", "--random", "--pattern", "'[a-z]{10} [A-Z]{10} [0-9]{10} [\!\@\#\$\%\^\&\*]{10}'"
    system bin/"passpie", "-D", "temp_db", "status", "--passphrase", "s3cr3t"
  end
end
