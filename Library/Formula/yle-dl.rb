class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.7.2.tar.gz"
  sha256 "7c4bea154ce91f171876c98d80d8a7cc56d0ffe925ed41302a09866226bdda92"

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
    url "https://raw.githubusercontent.com/K-S-V/Scripts/460814d210e8e19a98bddd12c178fc3b5f43b0bb/AdobeHDS.php"
    sha256 "7087e3857ef7335717e142996e27c5546806b0babd92cd540d783ae4ce2bcf3f"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
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
