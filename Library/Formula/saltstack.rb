class Saltstack < Formula
  desc "Dynamic infrastructure communication bus"
  homepage "http://www.saltstack.org"
  url "https://github.com/saltstack/salt/archive/v2015.5.0.tar.gz"
  sha256 "278142ffd4d6ec693a7d160c27d360e9fdce6ae9c7de40e3cb18805078488b71"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "cf9d2aee286f69efcd838021b9e21fcb87189e4c4f1b32a01213ed63dd1154e4" => :yosemite
    sha256 "84096f34d6f8940236594f8c08ac7fe344e5878026c829b96edc772d87b82e95" => :mavericks
    sha256 "03493a5a2cb2e9e203691e1ff15473f7ddb718c9a6c12e386782b055ef68262d" => :mountain_lion
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

  # Don't depend on Homebrew's openssl due to upstream build issues with non-system OpenSSL in M2Crypto
  # See: https://github.com/martinpaljak/M2Crypto/issues/11
  resource "m2crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha256 "6071bfc817d94723e9b458a010d565365104f84aa73f7fe11919871f7562ff72"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
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
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.3.1.tar.gz"
    sha256 "00e263c26a524f81127247e6f37cbf427eddf3a3657d170cf4865bd522df3914"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.2.tar.gz"
    sha256 "0476e8fdd79e5b648b349bd0edebf06e41271ee29421ef7adb12cdbe55dac2a9"
  end

  resource "apache-libcloud" do
    url "https://pypi.python.org/packages/source/a/apache-libcloud/apache-libcloud-0.15.1.tar.gz"
    sha256 "f12f80c2f66e46c406c53b90c41eb572c29751c407bdbe7204ec6d9264ce16bc"
  end

  # Required by tornado
  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-14.05.14.tar.gz"
    sha256 "1e1bcbacd6357c151ae37cf0290dcc809721d32ce21fd6b7339568f3ddef1b69"
  end

  # Required by tornado
  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.1.tar.gz"
    sha256 "99abd3aede45c93739346ee7384e710120121c3744da155d5cff1c0101702228"
  end

  def install
    resource("swig304").stage do
      system "./configure", "--disable-dependency-tracking", "--prefix=#{buildpath}/swig"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PATH", buildpath/"swig/bin"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    rs = %w[requests pycrypto pyyaml markupsafe jinja2 pyzmq msgpack-python apache-libcloud]
    rs += %w[certifi backports.ssl_match_hostname tornado] if build.head?

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

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/salt", "--version"
  end
end
