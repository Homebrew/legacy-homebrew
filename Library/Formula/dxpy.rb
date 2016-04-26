class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://pypi.python.org/packages/source/d/dxpy/dxpy-0.182.1.tar.gz"
  sha256 "0022f5f89e64b994b8c4cbcf596b0e514d9958569e7fc000ae36d5a49cdf1e9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6992446c517b78e4403496fdb66880874073b245443051818e10d6d7591fb4a" => :el_capitan
    sha256 "ba2a6fa30bef04d14dd9e8a9d346077ba67f46aa58753d4297dd1731ff470767" => :yosemite
    sha256 "ef227fb761e15e46d7c1fb662e7d8c0a056bc4eb9fcf6c7262243134740b77cf" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.4.tar.gz"
    sha256 "19485d83f7bd2151c0aeaf88fbba3ee50dadfb222ffc3b66a344ef4952b782a3"
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
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "argcomplete" do
    url "https://pypi.python.org/packages/source/a/argcomplete/argcomplete-0.8.1.tar.gz"
    sha256 "12e36f784160547ca855a2c9d753cf60cd3f87cab72b1e4993ceffb6ba51443b"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-3.3.0.tar.gz"
    sha256 "421b6591d16b509aaa8d8c15821d66bb94cb4a8dc4385cad5c51b85d4a096d85"
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
