class Duplicity < Formula
  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://code.launchpad.net/duplicity/0.6-series/0.6.25/+download/duplicity-0.6.25.tar.gz"
  sha256 "ac44f44abc1c5fe775a49b77e722d238c0b3bbb105e083fd505e2dca8e2c1725"
  revision 1

  devel do
    url "https://code.launchpad.net/duplicity/0.7-series/0.7.02/+download/duplicity-0.7.02.tar.gz"
    sha256 "609462ba43275340ae4fc008ee6620265cdc2c68988caae289971dd609ed033a"
  end

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
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.10.tar.gz"
    sha256 "e712ff3a18604833f5073e836aad795b21170b19bbef70947c441ed89d0ac0e1"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.10.tar.bz2"
    sha256 "387f968fde793b142865802916561839f5591d8b4b14c941125eb0fca7e4e58d"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-1.3.tar.gz"
    sha256 "9f02d0357184de1f093c10012b52e7454a1008be6a5c185ab7a3307aceb1d12e"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-0.10.7.tar.gz"
    sha256 "3219912992192c68d21885409ff853ab97b19559c6b5f9f76fd84f06b00f7a27"
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
    url "https://pypi.python.org/packages/source/o/oslo.i18n/oslo.i18n-1.3.1.tar.gz"
    sha256 "8e1b9b3f87cea9e43a2414bb02d8c79b0a688c916afa1f1453f6a0a65ffd85f6"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/source/o/oslo.utils/oslo.utils-1.2.1.tar.gz"
    sha256 "9cd8bcde345554582fd12c6daab81a7327a90c72861aa644e8b7b3fbfed5deba"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/source/o/oslo.serialization/oslo.serialization-1.2.0.tar.gz"
    sha256 "073f25ef4b7138e28ecb75bab413582c4dc1a54ab63b540a1702edee7c0a0557"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.2.0.tar.gz"
    sha256 "3f70db9052c26e66dac61cb73d8c6f5211373983d39872addab617c759db4b45"
  end

  resource "oslo.config" do
    url "https://pypi.python.org/packages/source/o/oslo.config/oslo.config-1.6.0.tar.gz"
    sha256 "a88cf1af696b4d9cae783a4c8c6898e6fb4abd176f9c9906ba388e7eac5eab17"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/source/p/python-keystoneclient/python-keystoneclient-1.0.0.tar.gz"
    sha256 "6d960d2196efc7a181519a77f757a27ceeeac71f41f624318ae7f1088d2e6db4"
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
    url "https://pypi.python.org/packages/source/f/futures/futures-2.2.0.tar.gz"
    sha256 "151c057173474a3a40f897165951c0e33ad04f37de65b6de547ddef107fd0ed3"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-2.3.1.tar.gz"
    sha256 "20a9d81dc0d948740a188a0c42e7f7fcc9c81a185bfbdf180f68580ea49309a6"
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
