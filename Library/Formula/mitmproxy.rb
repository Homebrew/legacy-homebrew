class Mitmproxy < Formula
  homepage "http://mitmproxy.org"
  url "https://mitmproxy.org/download/mitmproxy-0.11.1.tar.gz"
  sha1 "130e233f815525ee5cd78daa7d061319dd1b39c1"

  bottle do
    cellar :any
    sha1 "3d0f14b82b87abf336807d4fa4da7a7a61e04a25" => :yosemite
    sha1 "8116bd3eeac3889ff1c2b506cd94e91305e18aec" => :mavericks
    sha1 "fd9aba002da89c6eafda77dd8ed3b236bce64bca" => :mountain_lion
  end

  option "with-pyamf", "Enable action message format (AMF) support for python"
  option "with-cssutils", "Enable beautification of CSS responses"

  depends_on "freetype"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf" => :optional

  resource "pyopenssl" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.14.tar.gz"
    sha1 "eb51f23f29703b647b0f194beaa9b2412c05e0f6"
  end

  resource "pillow" do
    url "https://github.com/python-imaging/Pillow/archive/2.4.0.tar.gz"
    sha1 "2e07dd7545177019331e8f3916335b69869e82b0"
  end

  resource "flask" do
    url "https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz"
    sha1 "d3d078262b053f4438e2ed3fd6f9b923c2c92172"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.3.5.tar.gz"
    sha1 "7a6e92f8ca482aab79835e1c9cd8410400792cd9"
  end

  resource "netlib" do
    url "https://pypi.python.org/packages/source/n/netlib/netlib-0.10.1.tar.gz"
    sha1 "f2a51f72f5cb4e1cb0949196d306f9c29e825958"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz"
    sha1 "e32b91c5a5d9609fb1d07d8685a884bab22ca6d0"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.2.1.tar.gz"
    sha1 "28bd77014cce92bcb09ccc11f93e558d02265082"
  end

  resource "pyamf" do
    url "https://pypi.python.org/packages/source/P/PyAMF/PyAMF-0.6.1.tar.gz"
    sha1 "825a5ee167c89d3a026347b409ae26cbf6c68530"
  end

  resource "cssutils" do
    url "https://pypi.python.org/packages/source/c/cssutils/cssutils-1.0.zip"
    sha1 "341e57dbb02b699745b13a9a3296634209d26169"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-0.7.tar.gz"
    sha1 "f57311a150be673724c724b873e363d96a359b3a"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-0.8.6.tar.gz"
    sha1 "4e82390201e6f30e9df8a91cd176df19b8f2d547"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.10.tar.gz"
    sha1 "378a7a987d40e2c1c42cad0b351a6fc0a51ed004"
  end

  resource "werkzeug" do
    url "https://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.9.6.tar.gz"
    sha1 "d1bc1153ea45c6951845338a8499d94bad46e316"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "itsdangerous" do
    url "https://pypi.python.org/packages/source/i/itsdangerous/itsdangerous-0.24.tar.gz"
    sha1 "0a6ae9c20cd72e89d75314ebc7b0f390f93e6a0d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    resource("pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    res = %w(cffi cryptography flask itsdangerous jinja2 lxml markupsafe netlib pyasn1 pycparser pyopenssl six urwid werkzeug)
    res << "pyamf" if build.with? "pyamf"
    res << "cssutils" if build.with? "cssutils"

    res.each do |r|
      resource(r).stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
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
