class Mitmproxy < Formula
  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://mitmproxy.org/download/mitmproxy-0.12.1.tar.gz"
  sha256 "a7a59faa1f79a97c5cbd7acdaca72cfbf9903b9e39823226bc5d8a30efc07e70"

  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "19a0d988f0b272585322917b0f2a097bce08de30df85587100b6dbea93a0f8df" => :yosemite
    sha256 "e1bd1b9ef8ee793080a981968e206327813279909bbab70659aa5b89125a465d" => :mavericks
    sha256 "b17ef14e92ea107b434ea19f48799852c45f49e1fb7d9370d7dd1eb26f6cda71" => :mountain_lion
  end

  option "with-pyamf", "Enable action message format (AMF) support for python"
  option "with-cssutils", "Enable beautification of CSS responses"

  depends_on "freetype"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf" => :optional

  resource "pyopenssl" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pillow" do
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-2.8.1.tar.gz"
    sha256 "8760c118a0215eba163f7782110e7efcdbb15f8a7321f3f61c5ac0dbbb12c996"
  end

  resource "flask" do
    url "https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz"
    sha256 "4c83829ff83d408b5e1d4995472265411d2c414112298f2eb4b359d9e4563373"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "netlib" do
    url "https://pypi.python.org/packages/source/n/netlib/netlib-0.12.1.tar.gz"
    sha256 "090ccaa44f4369f0aa98a831e021277bcd45fdf7d7f00af282073cc7343ce79b"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz"
    sha256 "e4f81d53c533f6bd9526b047f047f7b101c24ab17339c1a7ad8f98b25c101eab"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.3.0.tar.gz"
    sha256 "29f04fad3bf0a79c5491f7ebec2d50fa086e9d16359896c9204c6a92bc07aba2"
  end

  resource "pyamf" do
    url "https://pypi.python.org/packages/source/P/PyAMF/PyAMF-0.7.2.tar.gz"
    sha256 "3e39d43989f75a4d35f4c2a591d8163637f67eaf856bdae749bd8b64b1c1b672"
  end

  resource "cssutils" do
    url "https://pypi.python.org/packages/source/c/cssutils/cssutils-1.0.zip"
    sha256 "4504762f5d8800b98fa713749c00acfef8419826568f9363c490e45146a891af"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-0.9.tar.gz"
    sha256 "ecfb96fdfda712ad21925c823013998c44322e862c54e7f1948970da42f2f771"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.1.0.tar.gz"
    sha256 "d8c1dcef421bf3b9335925dd5bf39c3fad923a3cbd814c3664d754638b32355e"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.13.tar.gz"
    sha256 "b399599a8a0e386bfcbc5e01a38d79dd6e926781f9e358cd5512f41ab7d20eb7"
  end

  resource "werkzeug" do
    url "https://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.10.4.tar.gz"
    sha256 "9d2771e4c89be127bc4bac056ab7ceaf0e0064c723d6b6e195739c3af4fd5c1d"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "itsdangerous" do
    url "https://pypi.python.org/packages/source/i/itsdangerous/itsdangerous-0.24.tar.gz"
    sha256 "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "configargparse" do
    url "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-0.9.3.tar.gz"
    sha256 "141c57112e1f8eb7e594a9820e95af897a7fa2d186cef5cff7e08cb3f7252829"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.2.tar.gz"
    sha256 "e8b1207da67dbdceebfb291292b4ef1b547d6171525bec1b366853f923456a5f"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.0.3.tar.gz"
    sha256 "06e729e1cbf5274703b1f47b6135ed8335999d547f9d8cf048b210fb8ebf844f"
  end

  resource "html2text" do
    url "https://pypi.python.org/packages/source/h/html2text/html2text-2015.6.6.tar.gz"
    sha256 "f4bffa87b38de50cf872340f210ec68cef8d9d152c4d78474bce388d4052274f"
  end

  resource "blinker" do
    url "https://pypi.python.org/packages/source/b/blinker/blinker-1.3.tar.gz"
    sha256 "6811010809262261e41ab7b92f3f6d23f35cf816fbec2bc05077992eebec6e2f"
  end

  resource "pyperclip" do
    url "https://pypi.python.org/packages/source/p/pyperclip/pyperclip-1.5.11.zip"
    sha256 "7087ab09b24d8c9a7b25570e360383ff85b9fa91a38b14eeff11de136b9e081f"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/source/p/passlib/passlib-1.6.2.tar.gz"
    sha256 "e987f6000d16272f75314c7147eb015727e8532a3b747b1a8fb58e154c68392d"
  end

  resource "hpack" do
    url "https://pypi.python.org/packages/source/h/hpack/hpack-1.0.1.tar.gz"
    sha256 "1868027f255e141ae2d194507f788a3d9d015ebe4982bec0e24a6b1b5ecae219"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.zip"
    sha256 "7583d80aca2a2b2a8a411f141c4d744de06a6bc43a32253f6b81d14d48f6c90e"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.7.tar.gz"
    sha256 "2c99e9eaea2dacbe4038b3be772ec650f5b4f4c8cc479c3704b81673d96849d7"
  end

  # Required by tornado
  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2015.04.28.tar.gz"
    sha256 "99785e6cf715cdcde59dee05a676e99f04835a71e7ced201ca317401c322ba96"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?

    resource("pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    res = %w[six cffi cryptography flask itsdangerous jinja2 lxml markupsafe pyasn1 pycparser pyopenssl
             pyparsing html2text urwid werkzeug configargparse tornado backports.ssl_match_hostname
             pyperclip blinker passlib hpack idna enum34 certifi ipaddress netlib]

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
