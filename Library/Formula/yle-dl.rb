class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.10.0.tar.gz"
  sha256 "90d7286a4609ec200a059360faba0557000c82957399fda7db04d8860982ff4e"

  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99a7718771e118ff5ceeb828ac1ea7ac4b8355431f6e7392a28b75d7b0d91195" => :el_capitan
    sha256 "5b8e85cfaddc9b9e979da27e76f45ca98eb6e8004103809bfcdfb5f9bf9c4bc9" => :yosemite
    sha256 "23e024faacf5f9ce1d951aa99db09da3c90674ea5c7cffcebe29790dba7597ba" => :mavericks
  end

  depends_on "rtmpdump"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "AdobeHDS.php" do
    # NOTE: yle-dl always installs the HEAD version of AdobeHDS.php. We use a specific commit.
    # Check if there are bugfixes at https://github.com/K-S-V/Scripts/commits/master/AdobeHDS.php
    url "https://raw.githubusercontent.com/K-S-V/Scripts/7e1c8d844e9907ea6407d74bc1d784e71ccb3ca3/AdobeHDS.php"
    sha256 "61a012547a97ebee3342ba37f9d01c2eed9cdd08674fc9d59cc1b266ce80494e"
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

    resource("AdobeHDS.php").stage(pkgshare)
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
