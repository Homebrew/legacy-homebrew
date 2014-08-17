require "formula"

class Keepassc < Formula
  homepage "http://raymontag.github.com/keepassc/"
  url "https://github.com/raymontag/keepassc/archive/1.6.2.tar.gz"
  sha1 "3366fc811b312ef2e64eb48a8b84380bc1a962b1"
  head "https://github.com/raymontag/keepassc.git", :branch => "development"

  depends_on :python3

  resource "pycrypto" do
    # homepage "https://www.dlitz.net/software/pycrypto"
    url "https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz"
    sha1 "aeda3ed41caf1766409d4efc689b9ca30ad6aeb2"
  end

  resource "kppy" do
    # homepage "https://github.com/raymontag/kppy"
    url "https://github.com/raymontag/kppy/archive/1.4.0.tar.gz"
    sha1 "12dfad16a6dddf045e23b658b2446d16e0d267f5"
  end

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python3.4/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource("pycrypto").stage { system "python3", *install_args }
    resource("kppy").stage { system "python3", *install_args }

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/'bin/*']
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    # Fetching help is the only non-interactive action we can perform,
    # and since interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc",  "--help"
  end
end
