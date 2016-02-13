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
    url "https://github.com/plusvic/yara/archive/v3.4.0.tar.gz"
    sha256 "528571ff721364229f34f6d1ff0eedc3cd5a2a75bb94727dc6578c6efe3d618b"
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
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-3.1.1.tar.gz"
    sha256 "486f4ccddee09429cb1c63ea56c02894aecf9d69acdcaf006c53835df2549fff"
  end

  resource "openpyxl" do
    url "https://pypi.python.org/packages/source/o/openpyxl/openpyxl-2.3.3.tar.gz"
    sha256 "93d64157d8cab5c7040bc025f0a7a9ad3c05e2d3f11518329c3f1682f5f62ffe"
  end

  resource "ipython" do
    url "https://pypi.python.org/packages/source/i/ipython/ipython-2.4.1.tar.gz"
    sha256 "6d350b5c2d3e925b0ff6167658812d720b891e476238d924504e2f7f483e9217"
  end

  resource "readline" do
    url "https://pypi.python.org/packages/source/r/readline/readline-6.2.4.1.tar.gz"
    sha256 "e00f86e03dfe52e7d1502cec5c64070b32621c85509c0081a4cfa6a0294bd107"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.gz"
    sha256 "99266ef30a37e43932deec2b7ca73e83c8dbc3b9ff703ec73eca6b1dae6befea"
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
