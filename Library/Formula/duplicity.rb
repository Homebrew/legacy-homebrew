class Duplicity < Formula
  homepage "http://www.nongnu.org/duplicity/"
  url "http://code.launchpad.net/duplicity/0.6-series/0.6.25/+download/duplicity-0.6.25.tar.gz"
  sha1 "fe0b6b0b0dc7dbc02598d96567954b48c4308420"
  revision 1

  bottle do
    sha256 "8b3e2f2ed2cc68ac4c991e9fe3fb3d0d10c3deade91f5709f174ee278fa81cbe" => :yosemite
    sha256 "937593295eb3f24892582d2f8b5724b3579ef5ad4ce659514879ec821bd031c3" => :mavericks
    sha256 "f5650df238e0350eab37b7147adb59fe18e4bf8c11e1175ec5b962d2294579e5" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "gnupg"

  option :universal

  # generated with homebrew-pypi-poet from
  # for i in boto pyrax dropbox mega.py paramiko pycrypto
  # lockfile python-swiftclient python-keystoneclient; do poet -r $i >>
  # resources; done

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.10.2.tar.gz"
    sha1 "1df8b1fad0c344230eaa7ce5fbf06521a74d7a6b"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha1 "f230ff9b041d3b43244086e38b7b6029450898be"
  end

  resource "PrettyTable" do
    url "https://pypi.python.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha1 "b26ece396f071665b0a7c041958a1187ce239fe7"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.10.tar.gz"
    sha1 "523f48ec579c49c0c1496c094282b684e07d4b36"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.10.tar.bz2"
    sha1 "74a1869c804dd422afbc49cb92206a0ca1529ddc"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-1.3.tar.gz"
    sha1 "7a43b1ee1539dca0baa37e9cb0706d1ba6631415"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-0.10.7.tar.gz"
    sha1 "8bed30aaa601fa4563546ddfd352fbba44d473dc"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.6.5.tar.gz"
    sha1 "4e3f2557fc8003115cf5d9c388845c03aec83121"
  end

  resource "netifaces" do
    url "https://pypi.python.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz"
    sha1 "c3fcd491a89c2994815053e853b005e7fc27c79a"
  end

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.13.tar.gz"
    sha1 "17570745e33dec8ddf4fdc7a4317f8dcfaa148fd"
  end

  resource "oslo.i18n" do
    url "https://pypi.python.org/packages/source/o/oslo.i18n/oslo.i18n-1.3.1.tar.gz"
    sha1 "ea244d0727e78b9b59eee6e60ef288eb98c9108f"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/source/o/oslo.utils/oslo.utils-1.2.1.tar.gz"
    sha1 "6de93eb3d3079e0c5ffe835ccc23fc7bf0867fdb"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/source/o/oslo.serialization/oslo.serialization-1.2.0.tar.gz"
    sha1 "54692ba90789d5f6d3c40c7ca628d6f296ec7b1a"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.2.0.tar.gz"
    sha1 "4d6b5ee39283532d72c52f909add9ef0af748062"
  end

  resource "oslo.config" do
    url "https://pypi.python.org/packages/source/o/oslo.config/oslo.config-1.6.0.tar.gz"
    sha1 "e840f7c9de6712e41372f07878ecca2f2758e2e8"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/source/p/python-keystoneclient/python-keystoneclient-1.0.0.tar.gz"
    sha1 "7287e548a64bb0541ccc2e1825f9c284d8478669"
  end

  resource "python-novaclient" do
    url "https://pypi.python.org/packages/source/p/python-novaclient/python-novaclient-2.20.0.tar.gz"
    sha1 "15888bb87cc7658701eaac346077260c870ace3a"
  end

  resource "rackspace-auth-openstack" do
    url "https://pypi.python.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha1 "fd1f9d0320db7c00563ef11ddcfc62ac9d545981"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-0.3.1.tar.gz"
    sha1 "e192b85bb6151aeb39d4abc75404fdb5ddd4abdc"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha1 "ba2b1d5f84448497e14e25922c5e3293f0a91c7e"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-4.1.zip"
    sha1 "877f1c1f0d58ff459320cb94f7c8ea9fe45c51d1"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_diskconfig_python_novaclient_ext/os_diskconfig_python_novaclient_ext-0.1.2.tar.gz"
    sha1 "7cab32cd6ffa6fde3ac4f3d6dc99a64fd0e8a9de"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_networksv2_python_novaclient_ext/os_networksv2_python_novaclient_ext-0.21.tar.gz"
    sha1 "c9ebe5c8242101d34fc84e22929edd2efd03ab4a"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_virtual_interfacesv2_python_novaclient_ext/os_virtual_interfacesv2_python_novaclient_ext-0.15.tar.gz"
    sha1 "fd6fe4118bdaada9d762dac66d197dbf12d855ba"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha1 "96845c352eada971d99eb967ee16468ccec3ee3b"
  end

  resource "rackspace-novaclient" do
    url "https://pypi.python.org/packages/source/r/rackspace-novaclient/rackspace-novaclient-1.4.tar.gz"
    sha1 "0219d3e4d507f31526743d1fc4a71a16bc760ef2"
  end

  resource "pyrax" do
    url "https://pypi.python.org/packages/source/p/pyrax/pyrax-1.9.3.tar.gz"
    sha1 "21d34aa5e43d01f97f8bdd7cf032a96f913f8f7c"
  end

  resource "urllib3" do
    url "https://pypi.python.org/packages/source/u/urllib3/urllib3-1.10.tar.gz"
    sha1 "8bb89da85d1bdb676616df4d07a02009ec40f08c"
  end

  resource "dropbox" do
    url "https://pypi.python.org/packages/source/d/dropbox/dropbox-2.2.0.zip"
    sha1 "164485502ad2f0a1deb834b58c964e7f618e9fd4"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha1 "aeda3ed41caf1766409d4efc689b9ca30ad6aeb2"
  end

  resource "mega.py" do
    url "https://pypi.python.org/packages/source/m/mega.py/mega.py-0.9.18.tar.gz"
    sha1 "f88be351702279010e6b9b52f86e79a5ec7ff3cf"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha1 "f732f8cdb064bbe47aa830cc2654688da95b78f0"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha1 "754ffa47fd6f78b93fc56437cf14a79bef094f0f"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-2.2.0.tar.gz"
    sha1 "0302253fb7e4fbbc48000b3e3dde244e9e7cd353"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-2.3.1.tar.gz"
    sha1 "fc2a84e59f6a851ee99e69b9c4de0023e5a33975"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    ENV.universal_binary if build.universal?

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    system bin/"duplicity", "--version"
  end
end
