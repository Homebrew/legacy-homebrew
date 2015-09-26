class Volatility < Formula
  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility"
  url "http://downloads.volatilityfoundation.org/releases/2.4/volatility-2.4.tar.gz"
  sha256 "684fdffd79ca4453298ee2eb001137cff802bc4b3dfaaa38c4335321f7cccef1"
  head "https://github.com/volatilityfoundation/volatility.git"

  bottle do
    revision 1
    sha1 "cf22cc05b0a17b14ebd781ce9ba8776df093fbfc" => :yosemite
    sha1 "fa9bf1f6eed8a25ebeef726bcb178858e9c97043" => :mavericks
    sha1 "f98e08887443635e783ca8bb2395b0737a810a93" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "yara"

  resource "yara-python" do
    url "https://github.com/plusvic/yara/archive/v3.2.0.tar.gz"
    sha256 "4a062ac3b44a3cb1487240e32d3dcbdb4e4d2e742174d87e36a95f18a3963507"
  end

  resource "distorm3" do
    url "https://distorm.googlecode.com/files/distorm3.zip"
    sha256 "d311d232e108def8acac0d4f6514e7bc070e37d7aa123ab9a9a05b9322321582"
  end

  resource "pycrypto" do
    url "https://github.com/dlitz/pycrypto/archive/v2.6.1.tar.gz"
    sha256 "41542a5be24da239e0841cb66e9dd28b772e79684b78d0b8292118e5c0d4e184"
  end

  resource "PIL" do
    url "http://effbot.org/downloads/Imaging-1.1.7.tar.gz"
    sha256 "895bc7c2498c8e1f9b99938f1a40dc86b3f149741f105cf7c7bd2e0725405211"
  end

  resource "openpyxl" do
    url "https://pypi.python.org/packages/source/o/openpyxl/openpyxl-2.0.5.tar.gz"
    sha256 "874c2f1180b0b6c84173abac1b9de87f4cb4eef59b83b3095ef345f77c824a93"
  end

  resource "ipython" do
    url "https://pypi.python.org/packages/source/i/ipython/ipython-2.2.0.tar.gz"
    sha256 "b7ca77ba54a02f032055b73f5f62b01431f818ae00f63716b78f881c2b2564e2"
  end

  resource "readline" do
    url "https://pypi.python.org/packages/source/r/readline/readline-6.2.4.1.tar.gz"
    sha256 "e00f86e03dfe52e7d1502cec5c64070b32621c85509c0081a4cfa6a0294bd107"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.4.tar.gz"
    sha256 "fddc081b9aead4d4ec09685c6e9ed6c7d3f5cace1ff7d39c76ba770f2c8d1049"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    res = %w[distorm3 pycrypto PIL openpyxl pytz ipython readline]

    res.each do |r|
      resource(r).stage do
        system "python", "setup.py", "build"
        system "python", "setup.py", "install", "--prefix=#{libexec}"
      end
    end

    resource("yara-python").stage do
      cd ("yara-python") do
        system "python", "setup.py", "build"
        system "python", "setup.py", "install", "--prefix=#{libexec}"
      end
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}",
               "--single-version-externally-managed", "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/vol.py", "--info"
  end
end
