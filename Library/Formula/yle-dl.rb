class YleDl < Formula
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.5.0.tar.gz"
  sha1 "6530a47b69a905f7ae92b97ded37c81437a8be72"

  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any
    sha1 "6816bec525d45aa0bfe2be7994cef9068bd4490f" => :yosemite
    sha1 "16eef04cd07d899e6397a5d364e0499278553dc4" => :mavericks
    sha1 "6d5fbf2f0daa11efeec1a660bc9ebf61ca834a04" => :mountain_lion
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
    assert_equal "3 minuuttia-2012-05-30T10:51:00\n",
                 shell_output("#{bin}/yle-dl --showtitle http://areena.yle.fi/tv/1570236")
  end
end
