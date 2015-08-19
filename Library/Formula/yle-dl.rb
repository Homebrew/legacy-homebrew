class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.7.2.tar.gz"
  sha256 "7c4bea154ce91f171876c98d80d8a7cc56d0ffe925ed41302a09866226bdda92"

  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any
    sha256 "2792ad1b8a6a2aa7bc9ba5821037ac5a691f9b650ebc18551cb3955ec53f7d84" => :yosemite
    sha256 "0af5fb9456cc26b7c92f7a03462189597d27b9229a74800a2094edac79125a09" => :mavericks
    sha256 "cb4a209ac0e68d168df8424813d6436501493850fef66ec710e5cdb41415cc44" => :mountain_lion
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
