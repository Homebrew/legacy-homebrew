class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.7.1.tar.gz"
  sha1 "041f212d56a981e1c53f6bdf042a281db965d6ed"

  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any
    sha256 "89a090fbe194bca747d62bfe31e24a57995d46c613dfe6258a7a5c0850e3afbc" => :yosemite
    sha256 "aa385837ea6e21d1f8cddb1d48784b071ef6bcc4a9692990c33f8cbefdffca85" => :mavericks
    sha256 "6837e267471c067acaae575bf6f60da08a585f74c1134e50fe388e8506b4fafa" => :mountain_lion
  end

  depends_on "rtmpdump"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "AdobeHDS.php" do
    # NOTE: yle-dl always installs the HEAD version of AdobeHDS.php. We use a specific commit.
    # Check if there are bugfixes at https://github.com/K-S-V/Scripts/commits/master/AdobeHDS.php
    url "https://raw.githubusercontent.com/K-S-V/Scripts/9c1afcc4b452cb9bf75f8653495c80180e2bf086/AdobeHDS.php"
    sha1 "bd562cb02087c83eea70a4e9a306be27980ee12c"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha1 "aeda3ed41caf1766409d4efc689b9ca30ad6aeb2"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("pycrypto").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    resource("AdobeHDS.php").stage(share/"yle-dl")
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"

    # change shebang to plain python (python2 is not guaranteed to exist)
    inreplace bin/"yle-dl", "#!/usr/bin/env python2", "#!/usr/bin/env python"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_equal "Yle - Sinun tarinasi: 3 minuuttia-2012-05-30T10:51:00+03:00\n",
                 shell_output("#{bin}/yle-dl --showtitle http://areena.yle.fi/1-1570236")
  end
end
