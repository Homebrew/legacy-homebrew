class Mitmproxy < Formula
  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "http://mitmproxy.org"
  url "https://mitmproxy.org/download/mitmproxy-0.11.3.tar.gz"
  sha256 "e774760fc33864caa708eeaafb756e110d7adeb619f3734f2f50b2a0e4910d5c"

  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "e18a2d3220157944d525c2812eae5dddbc91fc0c929dca06fa42399e44951a16" => :yosemite
    sha256 "0c64ded5eed5672fcca4a40775bcc908b0498be78529bbcb33e63de1590923b5" => :mavericks
    sha256 "2a8e214e45c73892512ef4fa05b8aa37e508cdfabef94517eef2bf80c68e5d3b" => :mountain_lion
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
    url "https://pypi.python.org/packages/source/n/netlib/netlib-0.11.2.tar.gz"
    sha256 "66dac408eccb528b284e6a6fa5bc52aa40d1c2a53d74179d3cb2253b3120851e"
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
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-0.8.2.tar.gz"
    sha256 "1c9a022ab3decaf152093e2ef2d5ee4258c72c7d429446c86bd68ff8c0929db6"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-0.8.6.tar.gz"
    sha256 "2532d9e3af9e3c6d0f710fc98b0295b563c7f39cfd97dd2242bd36fbf4900610"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.12.tar.gz"
    sha256 "da24c80aeb3c794ac64fe5503a01f65f13fece3e02513fd2e0761f93c96597b0"
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
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.1.tar.gz"
    sha256 "99abd3aede45c93739346ee7384e710120121c3744da155d5cff1c0101702228"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    res = %w[cffi cryptography flask itsdangerous jinja2 lxml markupsafe netlib pyasn1 pycparser pyopenssl six urwid werkzeug configargparse tornado backports.ssl_match_hostname]
    res << "pyamf" if build.with? "pyamf"
    res << "cssutils" if build.with? "cssutils"

    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    system bin/"mitmproxy", "--version"
  end
end
