class Saltstack < Formula
  desc "Dynamic infrastructure communication bus"
  homepage "http://www.saltstack.org"
  # please use sdists published as release downloads
  # (URLs starting with https://github.com/saltstack/salt/releases/download)
  # github tag archives will report wrong version number
  # https://github.com/Homebrew/homebrew/issues/43493
  url "https://github.com/saltstack/salt/releases/download/v2015.8.5/salt-2015.8.5.tar.gz"
  sha256 "db395702f048ea384ccc440201c24d7044685977ae6a8588d0d0933246f0c673"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "f1bfa2c891eb921b700fd491e9c67bde3b264381ddcce2ed32b48c584bd976dc" => :el_capitan
    sha256 "21a2538778070cde23596876dbbfb559cd1da1eb7f87e6cf96e3a63790a358f7" => :yosemite
    sha256 "23c358dbcf178e170e51136e556134024cf2079ef34e6b35a77ee9c84cf090ea" => :mavericks
  end

  depends_on "swig" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "zeromq"
  depends_on "libyaml"
  depends_on "openssl" # For M2Crypto

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "m2crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.23.0.tar.gz"
    sha256 "1ac3b6eafa5ff7e2a0796675316d7569b28aada45a7ab74042ad089d15a9567f"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
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
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-15.2.0.tar.gz"
    sha256 "2dafa322670a94e20283aba2a44b92134d425bd326419b68ad4db8d0831a26ec"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  # Required by tornado
  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2015.11.20.1.tar.gz"
    sha256 "30b0a7354a1b32caa8b4705d3f5fb2dadefac7ba4bf8af8a2176869f93e38f16"
  end

  # Required by tornado
  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  # Required by tornado
  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  # Required by tornado
  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        # M2Crypto always has to be done individually as we have to inreplace OpenSSL path
        inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'" if r.name == "m2crypto"
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
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
