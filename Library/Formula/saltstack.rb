class Saltstack < Formula
  desc "Dynamic infrastructure communication bus"
  homepage "http://www.saltstack.org"
  # please use sdists published as release downloads
  # (URLs starting with https://github.com/saltstack/salt/releases/download)
  # github tag archives will report wrong version number
  # https://github.com/Homebrew/homebrew/issues/43493
  url "https://github.com/saltstack/salt/releases/download/v2015.8.0/salt-2015.8.0.tar.gz"
  sha256 "71e1cb2eb1d4b30f3247f5590c00a2089190b8f9a90c9330dc9a65fae517ec9b"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "77ee45a43b886a6f9e4744fabb03ec60ab4b3dfc9fcc99d1738894ea3d63158b" => :el_capitan
    sha256 "eca29cf538c0fba986d2160f72f195f5bfce221ef5601f9bf584085107385d4a" => :yosemite
    sha256 "c28dc5586b07390c04125d55547ef9f46516ac080fc66a5527440c111bab9cf6" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "zeromq"
  depends_on "libyaml"
  depends_on "openssl" # For M2Crypto

  # For vendored Swig
  depends_on "pcre" => :build

  # Homebrew's swig breaks M2Crypto due to upstream's undermaintained status.
  # https://github.com/swig/swig/issues/344
  # https://github.com/martinpaljak/M2Crypto/issues/60
  resource "swig304" do
    url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.4/swig-3.0.4.tar.gz"
    sha256 "410ffa80ef5535244b500933d70c1b65206333b546ca5a6c89373afb65413795"
  end

  resource "m2crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha256 "6071bfc817d94723e9b458a010d565365104f84aa73f7fe11919871f7562ff72"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.3.tar.gz"
    sha256 "2fe2342bb4fe8b8e217f0d21b5921cbe5408bf966d9f92025e707e881b198bed"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.7.0.tar.gz"
    sha256 "77994f80360488e7153e64e5959dc5471531d1648e3a4bff14a714d074a38cc2"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  # Required by tornado
  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2015.9.6.2.tar.gz"
    sha256 "dc3a2b2d9d1033dbf27586366ae61b9d7c44d8c3a6f29694ffcbb0618ea7aea6"
  end

  # Required by tornado
  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.2.1.tar.gz"
    sha256 "a16fcdc4f76b184cb82f4f9eaeeacef6113b524b26a2cb331222e4a7fa6f2969"
  end

  def install
    resource("swig304").stage do
      system "./configure", "--disable-dependency-tracking", "--prefix=#{buildpath}/swig"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PATH", buildpath/"swig/bin"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    rs = %w[requests futures pycrypto pyyaml markupsafe jinja2 pyzmq msgpack-python]
    rs += %w[certifi backports.ssl_match_hostname tornado]
    rs.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # M2Crypto always has to be done individually as we have to inreplace OpenSSL path
    resource("m2crypto").stage do
      inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    man1.install Dir["doc/man/*.1"]
    man7.install Dir["doc/man/*.7"]

    # Install sample configuration files
    (etc/"saltstack").install Dir["conf/*"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    Sample configuration files have been placed in #{etc}/saltstack.
    Saltstack will not use these by default.
    EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    system "python", "-c", "import M2Crypto"

    system "#{bin}/salt", "--version"
  end
end
