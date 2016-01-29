class Mitmproxy < Formula
  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://mitmproxy.org/download/mitmproxy-0.15.tar.gz"
  sha256 "3565086026b5ca0b048e826498a9ed9b37489f5b5639a728d280f73783914aac"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    revision 1
    sha256 "58c50450515bc3a3299bf047b7f0ca2271e4ae77a963ff2fd0cc9ce3d3db0b4f" => :el_capitan
    sha256 "1c2a1581063a02f7ea8f3c759c8556c10f5bf26089250dbf32116d055671db06" => :yosemite
    sha256 "5d1e31f02b7c7b7c1578d42ddd6f3539f37312405119ed4be63540a6a08a85e1" => :mavericks
  end

  option "with-pyamf", "Enable action message format (AMF) support for python"
  option "with-cssutils", "Enable beautification of CSS responses"

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf" => :optional

  resource "argh" do
    url "https://pypi.python.org/packages/source/a/argh/argh-0.26.1.tar.gz"
    sha256 "06a7442cb9130fb8806fe336000fcf20edf1f2f8ad205e7b62cec118505510db"
  end

  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "blinker" do
    url "https://pypi.python.org/packages/source/b/blinker/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2015.11.20.1.tar.gz"
    sha256 "30b0a7354a1b32caa8b4705d3f5fb2dadefac7ba4bf8af8a2176869f93e38f16"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.0.tar.gz"
    sha256 "44f76f6c3fc654860821785192eca29bd66531af57d09b681e6d52584604a7e7"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.2.tar.gz"
    sha256 "fba0ff70f5ebb4cebbf64c40a8fbc222fb7cf825237241e548354dabe3da6a82"
  end

  resource "ConfigArgParse" do
    url "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-0.10.0.tar.gz"
    sha256 "3b50a83dd58149dfcee98cb6565265d10b53e9c0a2bca7eeef7fb5f5524890a7"
  end

  resource "construct" do
    url "https://pypi.python.org/packages/source/c/construct/construct-2.5.2.tar.gz"
    sha256 "665b6271eeadf15219c726b180c8d7a641d026784d72ca3dad90a20aae009020"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.1.2.tar.gz"
    sha256 "7f51459f84d670444275e615839f4542c93547a12e938a0a4906dafe5f7de153"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
  end

  resource "hpack" do
    url "https://pypi.python.org/packages/source/h/hpack/hpack-2.0.1.tar.gz"
    sha256 "0d7eaafeecfb60c18cbfd1c8ffb032bca4524862d0d89540e8a62d5118529ccc"
  end

  resource "html2text" do
    url "https://pypi.python.org/packages/source/h/html2text/html2text-2015.11.4.tar.gz"
    sha256 "44531c00fd125d0d987adf4e5ab6b4a8a2b44bfa5c4dc8896f50aa0e35c33708"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "netlib" do
    url "https://pypi.python.org/packages/source/n/netlib/netlib-0.15.1.tar.gz"
    sha256 "f55ad129b770fcf82786fb59d3e4f4291ea4c6dca4e4850bce1977bd9e99492e"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/source/p/passlib/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "pathtools" do
    url "https://pypi.python.org/packages/source/p/pathtools/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "Pillow" do
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-3.0.0.tar.gz"
    sha256 "ad50bef540fe5518a4653c3820452a881b6a042cb0f8bb7657c491c6bd3654bb"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.0.7.tar.gz"
    sha256 "2ce0db3c70ec0413603d4aea389e4ece34ff93c265649b1c5c7d56e3c2cf19c4"
  end

  resource "pyperclip" do
    url "https://pypi.python.org/packages/source/p/pyperclip/pyperclip-1.5.26.zip"
    sha256 "15929bdb305ca54ff090f066de985aa7b21f3d5f0b695edab880f0246559a88b"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "watchdog" do
    url "https://pypi.python.org/packages/source/w/watchdog/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  # Optional resources
  resource "pyamf" do
    url "https://pypi.python.org/packages/source/P/PyAMF/PyAMF-0.7.2.tar.gz"
    sha256 "3e39d43989f75a4d35f4c2a591d8163637f67eaf856bdae749bd8b64b1c1b672"
  end

  resource "cssutils" do
    url "https://pypi.python.org/packages/source/c/cssutils/cssutils-1.0.zip"
    sha256 "4504762f5d8800b98fa713749c00acfef8419826568f9363c490e45146a891af"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?

    resource("Pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    res = %w[argh backports_abc backports.ssl_match_hostname blinker certifi cffi
             click ConfigArgParse construct cryptography enum34 hpack html2text idna
             ipaddress lxml netlib passlib pathtools pyasn1 pycparser pyOpenSSL
             pyparsing pyperclip PyYAML singledispatch six tornado urwid watchdog]

    res << "pyamf" if build.with? "pyamf"
    res << "cssutils" if build.with? "cssutils"

    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    system bin/"mitmproxy", "--version"
  end
end
