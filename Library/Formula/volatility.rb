class Volatility < Formula
  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility"
  url "http://downloads.volatilityfoundation.org/releases/2.5/volatility-2.5.zip"
  sha256 "b90dfd18b6a99e1b35ef0f92f28422cca03bea0b7b8ec411cfbc603e72aa594b"
  head "https://github.com/volatilityfoundation/volatility.git"

  bottle do
    sha256 "1ecd23ba458142709598b16e9187a02b223ecc3443b996d4ce18c2618e472c58" => :el_capitan
    sha256 "803f179496272348a701733060a33617c0350c25d1d4a186c4fdb552a530ffff" => :yosemite
    sha256 "c570146019f2b92b5dc0384f53ecdc16eebbac7dee81fc8aab7ff7eb5adc71fd" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "yara"
  depends_on "jpeg"
  depends_on "freetype"

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

  resource "pillow" do
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-3.0.0.tar.gz"
    sha256 "ad50bef540fe5518a4653c3820452a881b6a042cb0f8bb7657c491c6bd3654bb"
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

    res = %w[distorm3 pycrypto openpyxl pytz ipython readline]

    res.each do |r|
      resource(r).stage do
        system "python", "setup.py", "build"
        system "python", "setup.py", "install", "--prefix=#{libexec}"
      end
    end

    resource("pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
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
