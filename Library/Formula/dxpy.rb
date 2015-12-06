class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://pypi.python.org/packages/source/d/dxpy/dxpy-0.172.0.tar.gz"
  sha256 "4ab4f761f6ee0f7d31189738373c76d8c93d0e3eea0fc7e166d61e183d8cc01c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5c3d99fd2ed6d1f88b5d942835921b20af0ad86dad521aeb93ddaf534ae3911" => :el_capitan
    sha256 "800d463fd4f11d35dd5354dd449721bb22b32d76b84d2b4149f294844909ac00" => :yosemite
    sha256 "88da6a2323f390d3b0cfcb193f5de2801ea6e7ef943f9886c948a3505ce92a94" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.3.tar.gz"
    sha256 "2fe2342bb4fe8b8e217f0d21b5921cbe5408bf966d9f92025e707e881b198bed"
  end

  resource "ws4py" do
    url "https://pypi.python.org/packages/source/w/ws4py/ws4py-0.3.2.tar.gz"
    sha256 "48a4e005496a60081f74ca130ce55603ff87e1507483535acf902b94761bda8b"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.3.tar.gz"
    sha256 "2db67d8832f19332908b4b9644865ced34087919702140862093e347e95730e4"
  end

  resource "python-magic" do
    url "https://pypi.python.org/packages/source/p/python-magic/python-magic-0.4.6.tar.gz"
    sha256 "903d3d3c676e2b1244892954e2bbbe27871a633385a9bfe81f1a81a7032df2fe"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz"
    sha256 "a2b29bd048ca2fe54a046b29770964738872a9747003a371344a93eedf7ad58e"
  end

  resource "argcomplete" do
    url "https://pypi.python.org/packages/source/a/argcomplete/argcomplete-0.8.1.tar.gz"
    sha256 "12e36f784160547ca855a2c9d753cf60cd3f87cab72b1e4993ceffb6ba51443b"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.1.3.tar.gz"
    sha256 "b434c75f01715777391f10f456002e33d0ca14633f96fdbd9ff9139b42d9452c"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "fusepy" do
    url "https://pypi.python.org/packages/source/f/fusepy/fusepy-2.0.2.tar.gz"
    sha256 "aa5929d5464caed81406481a330dc975d1a95b9a41d0a98f095c7e18fe501bfc"
  end

  resource "xattr" do
    url "https://pypi.python.org/packages/source/x/xattr/xattr-0.6.4.tar.gz"
    sha256 "f9dcebc99555634b697fa3dad8ea3047deb389c6f1928d347a0c49277a5c0e9e"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "gnureadline" do
    url "https://pypi.python.org/packages/source/g/gnureadline/gnureadline-6.3.3.tar.gz"
    sha256 "a259b038f4b625b07e6206bbc060baa5489ca17c798df3f9507875f2bf980cbe"
  end

  def install
    # gnureadline build script uses -arch. The superenv process was removing the -arch flags which causes gnureadline to fail. See #44472.
    ENV.permit_arch_flags
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    dxenv = <<-EOS.undent
    API server protocol	https
    API server host		api.dnanexus.com
    API server port		443
    Current workspace	None
    Current folder		None
    Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
