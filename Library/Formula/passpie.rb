class Passpie < Formula
  homepage "https://marcwebbie.github.io/passpie"
  url "https://pypi.python.org/packages/source/p/passpie/passpie-0.2.1.tar.gz"
  sha256 "d8a0281e188624ad9d40198c7402f59d2d822dd34ac361a7de79cfcdfae5ecca"
  head "https://github.com/marcwebbie/passpie.git"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :gpg

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
  end

  resource "gnupg" do
    url "https://pypi.python.org/packages/source/g/gnupg/gnupg-2.0.2.tar.gz"
    sha256 "67fa884d7700914ef623721c38c38fbbd9659825b65bcc81884a1772f12713df"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  resource "tinydb" do
    url "https://pypi.python.org/packages/source/t/tinydb/tinydb-2.3.2.zip"
    sha256 "bac0641924ae5a1561160b1a259a1e74f98e985a59a317625fdd7790ed8792c6"
  end

  resource "pyperclip" do
    url "https://pypi.python.org/packages/source/p/pyperclip/pyperclip-1.5.10.zip"
    sha256 "edaed3a21a90b73d8389f24a4d44078e3f6929b7cebbf54a909af3596fe145d6"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[tabulate psutil gnupg PyYAML click tinydb pyperclip].each do |r|
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
    system bin/"passpie", "-D", "temp_db", "update", "foo@bar", "--comment", "dummy comment"
    system bin/"passpie", "-D", "temp_db", "export", "passwords.db", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "remove", "-y", "foo@bar"
    system bin/"passpie", "-D", "temp_db", "remove", "-y", "spam@egg"
    system bin/"passpie", "-D", "temp_db", "import", "passwords.db"
    system bin/"passpie", "-D", "temp_db", "copy", "foo@bar", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "init", "--force", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "temp_db", "add", "foo@bar", "--password", "sup3r p4ssw0rd"
    system bin/"passpie", "-D", "temp_db", "status", "--passphrase", "s3cr3t"
  end
end
