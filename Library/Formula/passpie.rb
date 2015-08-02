class Passpie < Formula
  desc "Manage login credentials from the terminal"
  homepage "https://marcwebbie.github.io/passpie"
  url "https://pypi.python.org/packages/source/p/passpie/passpie-0.3.2.tar.gz"
  sha256 "b3d02da1350d44b9d283604f053a9ec0612a212972310facae0a7688da1fb99c"
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
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "smmap" do
    url "https://pypi.python.org/packages/source/s/smmap/smmap-0.9.0.tar.gz"
    sha256 "0e2b62b497bd5f0afebc002eda4d90df9d209c30ef257e8673c90a6b5c119d62"
  end

  resource "gitdb" do
    url "https://pypi.python.org/packages/source/g/gitdb/gitdb-0.6.4.tar.gz"
    sha256 "a3ebbc27be035a2e874ed904df516e35f4a29a778a764385de09de9e0f139658"
  end

  resource "GitPython" do
    url "https://pypi.python.org/packages/source/G/GitPython/GitPython-1.0.1.tar.gz"
    sha256 "9c88c17bbcae2a445ff64024ef13526224f70e35e38c33416be5ceb56ca7f760"
  end

  resource "tinydb" do
    url "https://pypi.python.org/packages/source/t/tinydb/tinydb-2.3.2.zip"
    sha256 "bac0641924ae5a1561160b1a259a1e74f98e985a59a317625fdd7790ed8792c6"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "gnupg" do
    url "https://pypi.python.org/packages/source/g/gnupg/gnupg-2.0.2.tar.gz"
    sha256 "67fa884d7700914ef623721c38c38fbbd9659825b65bcc81884a1772f12713df"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[tabulate psutil gnupg PyYAML click tinydb GitPython gitdb smmap].each do |r|
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
