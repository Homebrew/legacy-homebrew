class Duplicity < Formula
  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://code.launchpad.net/duplicity/0.6-series/0.6.26/+download/duplicity-0.6.26.tar.gz"
  sha256 "8bef8a5d805b79ae177e54d42152238bce1b2aaf9ad32e03a2c3a20cbd4e074a"
  revision 1

  bottle do
    sha256 "d0d199e6f41d174fad40ff8efc9855ce73689233c45d84f8cc3f6751651c5b26" => :yosemite
    sha256 "8ede776beaa93637a953e2cc75742a2c2f67da420e686e6ab7d33762ffb68049" => :mavericks
    sha256 "c6efc81584a839d6f6f0da4fa1ff25c384468bfd18d962867427515d2b95b85c" => :mountain_lion
  end

  devel do
    url "https://code.launchpad.net/duplicity/0.7-series/0.7.04/+download/duplicity-0.7.04.tar.gz"
    sha256 "b49fb7bbdf0a457adf67e9c9127c107695437cef135aca69bca90d495a97dd7a"
  end

  option :universal

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "gnupg"

  # generated with homebrew-pypi-poet from
  # for i in boto pyrax dropbox mega.py paramiko pycrypto
  # lockfile python-swiftclient python-keystoneclient; do poet -r $i >>
  # resources; done

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.10.2.tar.gz"
    sha256 "9e42252f17d1dd89ee31745e0c4fbe58862c25147eb0ef5295c9cd9bcb4ea2c1"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.36.0.tar.gz"
    sha256 "8033c6f7a7252976df0137b62536cfe38f1dbd1ef443a7a6d8bc06c063bc36bd"
  end

  resource "PrettyTable" do
    url "https://pypi.python.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.10.tar.gz"
    sha256 "e712ff3a18604833f5073e836aad795b21170b19bbef70947c441ed89d0ac0e1"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/source/m/monotonic/monotonic-0.3.tar.gz"
    sha256 "2825ba5ded67b1a70d44529634d3f4ddfad67a5ed7fdcf026022a3ce175be07b"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.4.tar.bz2"
    sha256 "a78b484d5472dd8c688f8b3eee18646a25c66ce45b2c26652850f6af9ce52b17"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.0.tar.gz"
    sha256 "44988df191123065af9857eca68e9151526a931c12659ca29904e4f11de7ec1b"
  end

  resource "debtcollector" do
    url "https://pypi.python.org/packages/source/d/debtcollector/debtcollector-0.7.0.tar.gz"
    sha256 "03ef06604e666a9f4a1506ffcfa887068bdb9f16e33657f9211a7b4e8bc753ea"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.5.0.tar.gz"
    sha256 "bd6db6ecddf5d8ab40d7d554508c29cfe0d150a1789f07d4dd32abe896068e7e"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.6.5.tar.gz"
    sha256 "2a3189f79d1c7b8a2149a0e783c0b4217fad9b30a6e7d60450f2553dc2c0e57e"
  end

  resource "netifaces" do
    url "https://pypi.python.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz"
    sha256 "9656a169cb83da34d732b0eb72b39373d48774aee009a3d1272b7ea2ce109cde"
  end

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.13.tar.gz"
    sha256 "ca42c260b49e5fd74ba9104efa6a4fca6b55316ca42714d20d2b9b8e751e0412"
  end

  resource "oslo.i18n" do
    url "https://pypi.python.org/packages/source/o/oslo.i18n/oslo.i18n-2.4.0.tar.gz"
    sha256 "b788a543416483196015177daf77c2d2a8ba84ea72b4372a7afa54707333308c"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/source/o/oslo.utils/oslo.utils-2.3.0.tar.gz"
    sha256 "c0ee7075a04a4c432d74d7b578fdc3478a5e831c9bd26fdff13b9bcc1e745ed4"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/source/o/oslo.serialization/oslo.serialization-1.8.0.tar.gz"
    sha256 "89156873f2dfa4aed0265ca9c27d7e66c9aff6cfd5b01cafd2eb4e6bd462579b"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.7.0.tar.gz"
    sha256 "68cf8691407cfd9c11e32381ef14ff566292dca0d113aba384d3fcc100933791"
  end

  resource "wrapt" do
    url "https://pypi.python.org/packages/source/w/wrapt/wrapt-1.10.5.tar.gz"
    sha256 "99cbb4e3a3ea964df0cb1437261fc1198616ec872e7b501622f3f7f92fcd0833"
  end

  resource "oslo.config" do
    url "https://pypi.python.org/packages/source/o/oslo.config/oslo.config-2.2.0.tar.gz"
    sha256 "8ecb41d524a5c09e9a06513936177c2b8df3494d065f6999df7c533370693e3d"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/source/p/python-keystoneclient/python-keystoneclient-1.6.0.tar.gz"
    sha256 "45ac3b13b8b63ab62cb3fbfcaf46a2241d8053dfe17961db911c45c1f23d06ff"
  end

  resource "python-novaclient" do
    url "https://pypi.python.org/packages/source/p/python-novaclient/python-novaclient-2.20.0.tar.gz"
    sha256 "73fc8169d58e910340aae1ac5370c3b63a9943f748e2a20e4a1dfd7277525c86"
  end

  resource "rackspace-auth-openstack" do
    url "https://pypi.python.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "336d60bdb836dd4e51b142f7977da57b078ad2104a6628eaef7135c67a627c70"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha256 "b839dd2d9c117c701430c149956918a423a9863b48b09c90e30a6013e7d2f44f"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-4.1.zip"
    sha256 "613087be1a0ad2870181ecc145b88459a576b6f434251cd559d41fc7f007760e"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_diskconfig_python_novaclient_ext/os_diskconfig_python_novaclient_ext-0.1.2.tar.gz"
    sha256 "78076a7b05afb8842734329f306bd69e64af6af910a3bc973fcf023723b8d7fc"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_networksv2_python_novaclient_ext/os_networksv2_python_novaclient_ext-0.21.tar.gz"
    sha256 "2598aaaf19a6897be8427a402bb10b772178ed3c8922d9d955fa411ed8ec11a8"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_virtual_interfacesv2_python_novaclient_ext/os_virtual_interfacesv2_python_novaclient_ext-0.15.tar.gz"
    sha256 "7d6c1371750568efc0f8a02e2b8d18fa885b9289ed25228252a2a6a5f0e53480"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "rackspace-novaclient" do
    url "https://pypi.python.org/packages/source/r/rackspace-novaclient/rackspace-novaclient-1.4.tar.gz"
    sha256 "68e1f53411b635f836a53d09e6c85f6a7d5d69d39df2e25a745406140cd5c275"
  end

  resource "pyrax" do
    url "https://pypi.python.org/packages/source/p/pyrax/pyrax-1.9.3.tar.gz"
    sha256 "0a3026c67df7bb84720cf562eef0fb15ad67dce79b6fc5e8da46621489be26bb"
  end

  resource "urllib3" do
    url "https://pypi.python.org/packages/source/u/urllib3/urllib3-1.10.tar.gz"
    sha256 "25b4a7fbbd9112e0190f31f8877aa0523caeab8630872ad1bbddaba01cdd6599"
  end

  resource "dropbox" do
    url "https://pypi.python.org/packages/source/d/dropbox/dropbox-2.2.0.zip"
    sha256 "66dcc404be00b98d7a12a7cc4465f16557e11a7e0e6916358038af6316cf3219"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "mega.py" do
    url "https://pypi.python.org/packages/source/m/mega.py/mega.py-0.9.18.tar.gz"
    sha256 "f3e15912ce2e5de18e31e7abef8a819a5546c184aa09586bfdaa42968cc827bf"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha256 "8e3b6c193f91dc94b2f3b0261e3eabbdc604f78ff99fdad324a56fdd0b5e958c"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha256 "4f56a671a3eecbb76e6143e6e4ca007d503a39aa79aa9e14ade667fa53fd6e55"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.3.tar.gz"
    sha256 "2fe2342bb4fe8b8e217f0d21b5921cbe5408bf966d9f92025e707e881b198bed"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-2.5.0.tar.gz"
    sha256 "6efcbff0bf60521ef682068c10c2d8959d887f70ed84ccd2def9945e8e94560e"
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
    system bin/"duplicity", "--dry-run", "--no-encryption",  testpath, "file:///#{testpath}/test"
  end
end
