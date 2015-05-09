class Passpie < Formula
  homepage "https://marcwebbie.github.io/passpie"
  url "https://github.com/marcwebbie/passpie/archive/v0.1.2.tar.gz"
  sha256 "c35b4d050db82100ae50ff85dfb3989f7618558b9b7802877a29c9734c38ac7c"
  head "https://github.com/marcwebbie/passpie.git"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :gpg

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "tinydb" do
    url "https://pypi.python.org/packages/source/t/tinydb/tinydb-2.3.1.post2.zip"
    sha256 "dfb132d0e7c4f11e987334b1a03bdd7e9bf238d3cd2322008f2d1c57d026e230"
  end

  resource "pyperclip" do
    url "https://pypi.python.org/packages/source/p/pyperclip/pyperclip-1.5.9.zip"
    sha256 "cd0a9a8299811298adfdaab9919c06075d70f72e03a53f95bcdc2f522dc1fabf"
  end

  resource "gnupg" do
    url "https://pypi.python.org/packages/source/g/gnupg/gnupg-2.0.2.tar.gz"
    sha256 "67fa884d7700914ef623721c38c38fbbd9659825b65bcc81884a1772f12713df"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[PyYAML psutil gnupg tabulate tinydb pyperclip click].each do |r|
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
    system "passpie", "--help"
    system "passpie", "--version"
    system "passpie", "-D", "temp_db", "init", "--passphrase", "s3cr3t"
    system "passpie", "-D", "temp_db", "add", "foo@bar", "--random"
    system "passpie", "-D", "temp_db", "add", "spam@egg", "--random"
    system "passpie", "-D", "temp_db", "update", "foo@bar", "--comment", "dummy comment"
    system "passpie", "-D", "temp_db", "export", "passwords.db", "--passphrase", "s3cr3t"
    system "passpie", "-D", "temp_db", "remove", "-y", "foo@bar"
    system "passpie", "-D", "temp_db", "remove", "-y", "spam@egg"
    system "passpie", "-D", "temp_db", "import", "passwords.db"
    system "passpie", "-D", "temp_db", "copy", "foo@bar", "--passphrase", "s3cr3t"
    system "passpie", "-D", "temp_db", "init", "--force", "--passphrase", "s3cr3t"
    system "passpie", "-D", "temp_db", "add", "foo@bar", "--password", "sup3r p4ssw0rd"
    system "passpie", "-D", "temp_db", "status", "--passphrase", "s3cr3t"
  end
end
