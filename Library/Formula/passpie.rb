class Passpie < Formula
  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://pypi.python.org/packages/source/p/passpie/passpie-1.3.0.tar.gz"
  sha256 "de3de4439dcbb90eddd9f5df3e21aa8a0bc9c539cb6c43fccb4cae07303854ff"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c916faedd52c2421b7ef4407c5e036ad653ead17620b04ee47305cc745310f3" => :el_capitan
    sha256 "9bd1106249dc25a0566e9963e00f0ff725653cf5fb58fe02d88fe9b92e66df93" => :yosemite
    sha256 "35f63abfb770a087312aa1dc517fd87ab42be4f4e6ea17cda6adac262d013eb1" => :mavericks
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

    # adding
    system bin/"passpie", "-D", "passpiedb", "add", "foo@example.com", "--random"
    system bin/"passpie", "-D", "passpiedb", "add", "foo2@example.com", "--random"
    system bin/"passpie", "-D", "passpiedb", "add", "bar@example.com", "--pattern", "[a-z]{30}"
    system bin/"passpie", "-D", "passpiedb", "add", "spam@example.com", "--copy", "--pattern", "[a-z]{30}"

    # updating
    system bin/"passpie", "-D", "passpiedb", "update", "foo@example.com", "--comment", "something"
    system bin/"passpie", "-D", "passpiedb", "update", "foo2@example.com", "--name", "example.org"
    system bin/"passpie", "-D", "passpiedb", "update", "foo2@example.org", "--login", "foo"
    system bin/"passpie", "-D", "passpiedb", "update", "spam@example.com", "--password", "p4ssw0rd"

    # copying
    system bin/"passpie", "-D", "passpiedb", "copy", "foo@example.com", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "passpiedb", "copy", "bar@example.com", "--passphrase", "s3cr3t"
    system bin/"passpie", "-D", "passpiedb", "copy", "spam@example.com", "--passphrase", "s3cr3t", "--to=stdout"

    # exporting
    system bin/"passpie", "-D", "passpiedb", "export", "--passphrase", "s3cr3t", "passwords.txt"

    # removing
    system bin/"passpie", "-D", "passpiedb", "remove", "-y", "foo@example.com"

    # status
    system bin/"passpie", "-D", "passpiedb", "status", "--passphrase", "s3cr3t"

    # purging and importing
    system bin/"passpie", "-D", "passpiedb", "purge", "-y"
    system bin/"passpie", "-D", "passpiedb", "import", "passwords.txt"
    system bin/"passpie", "-D", "passpiedb"

    # logging
    system bin/"passpie", "-D", "passpiedb", "log"

    # completion
    system bin/"passpie", "-D", "passpiedb", "complete", "bash"
    system bin/"passpie", "-D", "passpiedb", "complete", "fish"
    system bin/"passpie", "-D", "passpiedb", "complete", "zsh"

    # config
    system bin/"passpie", "config", "global"
    system bin/"passpie", "config", "local"
    system bin/"passpie", "config", "current"
  end
end
