class Keepassc < Formula
  homepage "http://raymontag.github.com/keepassc/"
  url "https://github.com/raymontag/keepassc/archive/1.7.0.tar.gz"
  sha1 "edc39b0aaaeaca101ab722cba7b19804b4b8f9b7"
  head "https://github.com/raymontag/keepassc.git", :branch => "development"

  bottle do
    cellar :any
    sha1 "fba4d1c078e87272829edb0450d415ba69f65928" => :yosemite
    sha1 "7a20f233d82f09d1fde95e382e83a321b05d04a7" => :mavericks
    sha1 "be234b537c09d85d9cc75d4085196f796f0994fa" => :mountain_lion
  end

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
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python3.4/site-packages"
    install_args = %W[setup.py install --prefix=#{libexec}]

    resource("pycrypto").stage { system "python3", *install_args }
    resource("kppy").stage { system "python3", *install_args }

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc",  "--help"
  end
end
