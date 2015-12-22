class Duplicity < Formula
  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://code.launchpad.net/duplicity/0.7-series/0.7.06/+download/duplicity-0.7.06.tar.gz"
  sha256 "0075595edb894399cf00fae9154aae93a07eaadc031fede5df4cc595436c7f8c"

  bottle do
    sha256 "36bfb11bd2f1fc81693e887c0b24e5af4b19579eac21af331c3e6eb9fd31c1e7" => :el_capitan
    sha256 "2ae2ec9a37b6b3efb137d693dec6069214383aa2c6fb35c36a32a7f26a472ee8" => :yosemite
    sha256 "7acacb17bfbe9d6a20e56ac819c296129b1537957285ab6a68e11d51ac15c8be" => :mavericks
  end

  option :universal

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on :gpg => :run

  # generated with homebrew-pypi-poet from
  # for i in boto pyrax dropbox mega.py paramiko pycrypto
  # lockfile python-swiftclient python-keystoneclient; do poet -r $i >>
  # resources; done

  # MacOS versions prior to Yosemite need the latest setuptools in order to compile dependencies
  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-19.1.1.tar.gz"
    sha256 "32ebb08b72aee11fefa6907ddf5db5a81e0eef9cf62c7fa6b58d8e32da249960"
  end

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  resource "PrettyTable" do
    url "https://pypi.python.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.8.1.tar.gz"
    sha256 "84fe8d5bf4dcdcc49002446c47a146d17ac10facf00d9086659064ac43b6c25b"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/source/m/monotonic/monotonic-0.4.tar.gz"
    sha256 "852f656adbf623ee859def6ca2f5498f4cae3256f8320d5c50570ee8a0592ab6"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.bz2"
    sha256 "fbd26746772c24cb93c8b97cbdad5cb9e46c86bbdb1b9d8a743ee00e2fb1fc5d"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.1.1.tar.gz"
    sha256 "7fb6d50effe88a087feb2036cb972fd7a893bf338361516f1a55a820bf7b5248"
  end

  resource "debtcollector" do
    url "https://pypi.python.org/packages/source/d/debtcollector/debtcollector-1.1.0.tar.gz"
    sha256 "87da37838bffbe61b7ba4986579e0ae06bc5f8eb2e197e89ef7419322655ae9b"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.8.1.tar.gz"
    sha256 "e2127626a91e6c885db89668976db31020f0af2da728924b56480fc7ccf09649"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.1.tar.gz"
    sha256 "428ac8f3219c78fb04ce05895d5dff9bd813c05a9a7922c53dc879cd32a12493"
  end

  resource "netifaces" do
    url "https://pypi.python.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz"
    sha256 "9656a169cb83da34d732b0eb72b39373d48774aee009a3d1272b7ea2ce109cde"
  end

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
  end

  resource "oslo.i18n" do
    url "https://pypi.python.org/packages/source/o/oslo.i18n/oslo.i18n-3.1.0.tar.gz"
    sha256 "1c82d9e3acd821015990fd111750fd949a5276ed6561a16e0a39d69e7145dbd8"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/source/o/oslo.utils/oslo.utils-3.2.0.tar.gz"
    sha256 "c3d73a2c4556d88acd4b3b25786dbab83ee31aaea68c4c98cd4d1bfb9965f281"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/source/o/oslo.serialization/oslo.serialization-2.1.0.tar.gz"
    sha256 "8f8cb079e285a878dc176189edd7dced278d2419cc4d3e262f6669650f851643"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.10.0.tar.gz"
    sha256 "f5d689ef38e0ca532d57a03d1ab95e89b17c57f97b58d10c92da94699973779f"
  end

  resource "wrapt" do
    url "https://pypi.python.org/packages/source/w/wrapt/wrapt-1.10.6.tar.gz"
    sha256 "9576869bb74a43cbb36ee39dc3584e6830b8e5c788e83edf0a397eba807734ab"
  end

  resource "oslo.config" do
    url "https://pypi.python.org/packages/source/o/oslo.config/oslo.config-3.1.0.tar.gz"
    sha256 "eeb79675d94963fa406d75c99ed7ac1110eef3134b1060670a3ebd67527edb2d"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/source/p/python-keystoneclient/python-keystoneclient-2.0.0.tar.gz"
    sha256 "6c8895cc15c3ee42a7aea588da297b31e68eaf7af1dfd89eae9ed4c95da17500"
  end

  resource "python-novaclient" do
    url "https://pypi.python.org/packages/source/p/python-novaclient/python-novaclient-2.35.0.tar.gz"
    sha256 "370838b48f72ad00aeeb470b00fe18cc8bc359df06a915ac526c4ef0c09e2cbb"
  end

  resource "rackspace-auth-openstack" do
    url "https://pypi.python.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-0.3.2.tar.gz"
    sha256 "bf18d534f6ab1ca1c82680a71d631babee285257c7d99321413a19d773790915"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-1.3.0.tar.gz"
    sha256 "1e247dbecc6ce057299eb7ee019ad68314bb93152e81d9a6110d35f4d5eca0f6"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-5.7.1.tar.gz"
    sha256 "3df352616b856a3aebd699ab2e946d4a6e3b0219e696d5416bfc4c16530eeac0"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_diskconfig_python_novaclient_ext/os_diskconfig_python_novaclient_ext-0.1.2.tar.gz"
    sha256 "78076a7b05afb8842734329f306bd69e64af6af910a3bc973fcf023723b8d7fc"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_networksv2_python_novaclient_ext/os_networksv2_python_novaclient_ext-0.25.tar.gz"
    sha256 "35ba71b027daf4c407d7a2fd94604d0437eea0c1de4d8d5d0f8ab69100834a0f"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/o/os_virtual_interfacesv2_python_novaclient_ext/os_virtual_interfacesv2_python_novaclient_ext-0.19.tar.gz"
    sha256 "5171370e5cea447019cee5da22102b7eca4d4a7fb3f12875e2d7658d98462c0a"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "rackspace-novaclient" do
    url "https://pypi.python.org/packages/source/r/rackspace-novaclient/rackspace-novaclient-1.5.tar.gz"
    sha256 "0fcde7e22594d9710c65e850d11898bd342fa83849dc8ef32c2a94117f7132b1"
  end

  resource "pyrax" do
    url "https://pypi.python.org/packages/source/p/pyrax/pyrax-1.9.5.tar.gz"
    sha256 "59ac98ae0549beb1eb36cc1f4985d565f126adbfa596d7fa5aaccde5ef194c0e"
  end

  resource "urllib3" do
    url "https://pypi.python.org/packages/source/u/urllib3/urllib3-1.12.tar.gz"
    sha256 "0ea512776971fe4e76192600fe41e4e7ee96b4b9a5b15aefc1ac31d2a63872c6"
  end

  resource "dropbox" do
    url "https://pypi.python.org/packages/source/d/dropbox/dropbox-4.0.tar.gz"
    sha256 "95f766839247b4c8c714dc3af9bab7b2b149e9fb507c7f2ba44ee321a76a684a"
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
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.16.0.tar.gz"
    sha256 "3297ebd3cd072f573772f7c7426939a443c62c458d54bb632ff30fd6ecf96892"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.3.tar.gz"
    sha256 "2fe2342bb4fe8b8e217f0d21b5921cbe5408bf966d9f92025e707e881b198bed"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-2.7.0.tar.gz"
    sha256 "013f3d8296f5b4342341e086e95c4a1fc85a24caa22a9bcc7de6716b20de2a55"
  end

  resource "pexpect" do
    url "https://pypi.python.org/packages/source/p/pexpect/pexpect-4.0.1.tar.gz"
    sha256 "232795ebcaaf2e120396dbbaa3a129eda51757eeaae1911558f4ef8ee414fc6c"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"

    ENV.universal_binary if build.universal?

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]

    # OSX doesn't provide a /usr/bin/python2. Upstream has been notified but
    # cannot fix the issue. See:
    #   https://github.com/Homebrew/homebrew/pull/34165#discussion_r22342214
    inreplace "#{libexec}/bin/duplicity", "python2", "python"
  end

  test do
    system bin/"duplicity", "--dry-run", "--no-encryption", testpath, "file:///#{testpath}/test"
  end
end
