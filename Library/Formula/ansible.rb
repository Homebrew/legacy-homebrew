class Ansible < Formula
  desc "Automate deployment, configuration, and upgrading"
  homepage "http://www.ansible.com/home"
  url "http://releases.ansible.com/ansible/ansible-1.9.2.tar.gz"
  sha256 "c25ef4738b08fdfb3094247c012f3fd1b29972acbd37f988070b2a85f5fbee00"

  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    revision 2
    sha256 "f7556845bc1ef41bab0cf257c4e81a5dc934114c597df38ee60a31d335ff3f47" => :yosemite
    sha256 "d3216454aacc4d592a49ccd2b2bd93fa158d77f24c64e7a527ec0017abfa347d" => :mavericks
    sha256 "51d17eb2a112240dfd1e25e8544e89adda3ab37c68d32210f10287ede128fe6e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on "openssl"

  #
  # ansible (core dependencies)
  #
  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha256 "4f56a671a3eecbb76e6143e6e4ca007d503a39aa79aa9e14ade667fa53fd6e55"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  #
  # Required by the 'paramiko' core module
  # https://github.com/paramiko/paramiko)
  #
  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  #
  # Required by the 'uri' core module
  # See http://docs.ansible.com/uri_module.html#requirements)
  #
  resource "httplib2" do
    url "https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.1.tar.gz"
    sha256 "bc6339919a5235b9d1aaee011ca5464184098f0c47c9098001f91c97176583f5"
  end

  #
  # Resources required by docker-py and pyrax (see below)
  #
  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  #
  # docker-py (for Docker support)
  #
  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.3.1.tar.gz"
    sha256 "743f3fc78f6159d14ac603def6470cf1b4edefc04de8b1ad8c349b380b503f50"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket_client-0.32.0.tar.gz"
    sha256 "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040"
  end

  #
  # pywinrm (for Windows support)
  #
  resource "isodate" do
    url "https://pypi.python.org/packages/source/i/isodate/isodate-0.5.1.tar.gz"
    sha256 "b12aed31c0e834543497e24d609a41531a800d8304c39e6665c45ca023b012fb"
  end

  resource "pywinrm" do
    url "https://pypi.python.org/packages/source/p/pywinrm/pywinrm-0.0.3.tar.gz"
    sha256 "be3775890effcddfb1fca440b43bf08af165527a7b102d43518232bfc9c021bc"
  end

  resource "xmltodict" do
    url "https://pypi.python.org/packages/source/x/xmltodict/xmltodict-0.9.2.tar.gz"
    sha256 "275d1e68c95cd7e3ee703ddc3ea7278e8281f761680d6bdd637bcd00a5c59901"
  end

  #
  # kerberos (for Windows support)
  #
  resource "kerberos" do
    url "https://pypi.python.org/packages/source/k/kerberos/kerberos-1.2.2.tar.gz"
    sha256 "070ff6d9baf3752323283b1c8ed75e2edd0ec55337359185abf5bb0b617d2f5d"
  end

  #
  # boto (for AWS support)
  #
  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  #
  # pyrax (for Rackspace support)
  #
  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.0.tar.gz"
    sha256 "44988df191123065af9857eca68e9151526a931c12659ca29904e4f11de7ec1b"
  end

  resource "debtcollector" do
    url "https://pypi.python.org/packages/source/d/debtcollector/debtcollector-0.7.0.tar.gz"
    sha256 "03ef06604e666a9f4a1506ffcfa887068bdb9f16e33657f9211a7b4e8bc753ea"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/source/f/funcsigs/funcsigs-0.4.tar.gz"
    sha256 "d83ce6df0b0ea6618700fe1db353526391a8a3ada1b7aba52fed7a61da772033"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.10.tar.gz"
    sha256 "e712ff3a18604833f5073e836aad795b21170b19bbef70947c441ed89d0ac0e1"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-5.3.zip"
    sha256 "ac2b4dc17e6edfb804b09ade15df79f251522e442976ea0c8ea0051474502cf5"
  end

  resource "mock" do
    # NOTE: mock versions above 1.0.1 fail to install due to a broken setuptools version check.
    url "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha256 "b839dd2d9c117c701430c149956918a423a9863b48b09c90e30a6013e7d2f44f"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/source/m/monotonic/monotonic-0.3.tar.gz"
    sha256 "2825ba5ded67b1a70d44529634d3f4ddfad67a5ed7fdcf026022a3ce175be07b"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.15.tar.gz"
    sha256 "d5b5bb3f4e9a94f93d232bb876e567517d8fb59e5bebb5339483b44df5529d11"
  end

  resource "netifaces" do
    url "https://pypi.python.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz"
    sha256 "9656a169cb83da34d732b0eb72b39373d48774aee009a3d1272b7ea2ce109cde"
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

  resource "oslo.config" do
    url "https://pypi.python.org/packages/source/o/oslo.config/oslo.config-2.2.0.tar.gz"
    sha256 "8ecb41d524a5c09e9a06513936177c2b8df3494d065f6999df7c533370693e3d"
  end

  resource "oslo.i18n" do
    url "https://pypi.python.org/packages/source/o/oslo.i18n/oslo.i18n-2.3.0.tar.gz"
    sha256 "9cd35cd12104672e4675465d59badf9b1d1c1bfc54ceef57d076d4fa8a12afc6"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/source/o/oslo.serialization/oslo.serialization-1.8.0.tar.gz"
    sha256 "89156873f2dfa4aed0265ca9c27d7e66c9aff6cfd5b01cafd2eb4e6bd462579b"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/source/o/oslo.utils/oslo.utils-2.2.0.tar.gz"
    sha256 "75edebbb9715d9658e12a0b1b510389f5af5b66da7035bae48b3c79c6ac14aad"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.4.0.tar.gz"
    sha256 "f080232fb6b208615b4c1854bf4277bb097d19c9ef89f94f203c1436fe600e92"
  end

  resource "PrettyTable" do
    url "https://pypi.python.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pyrax" do
    url "https://pypi.python.org/packages/source/p/pyrax/pyrax-1.9.4.tar.gz"
    sha256 "5cc27688cccd4137a4c53a69b6e0e877054a0bafec899f8170ccc0b58fbf95f3"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/source/p/python-keystoneclient/python-keystoneclient-1.6.0.tar.gz"
    sha256 "45ac3b13b8b63ab62cb3fbfcaf46a2241d8053dfe17961db911c45c1f23d06ff"
  end

  resource "python-novaclient" do
    url "https://pypi.python.org/packages/source/p/python-novaclient/python-novaclient-2.26.0.tar.gz"
    sha256 "725e28e981422e051352a76947dfab05838ee687f3c73a6524d64be8af8a900f"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.4.tar.bz2"
    sha256 "a78b484d5472dd8c688f8b3eee18646a25c66ce45b2c26652850f6af9ce52b17"
  end

  resource "rackspace-auth-openstack" do
    url "https://pypi.python.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://pypi.python.org/packages/source/r/rackspace-novaclient/rackspace-novaclient-1.4.tar.gz"
    sha256 "68e1f53411b635f836a53d09e6c85f6a7d5d69d39df2e25a745406140cd5c275"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "336d60bdb836dd4e51b142f7977da57b078ad2104a6628eaef7135c67a627c70"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.0.tar.gz"
    sha256 "217e4797da3a9a4a9fbe6722e0db98070b8443a88212d7acdbd241a7668141d9"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.7.0.tar.gz"
    sha256 "68cf8691407cfd9c11e32381ef14ff566292dca0d113aba384d3fcc100933791"
  end

  resource "wrapt" do
    url "https://pypi.python.org/packages/source/w/wrapt/wrapt-1.10.5.tar.gz"
    sha256 "99cbb4e3a3ea964df0cb1437261fc1198616ec872e7b501622f3f7f92fcd0833"
  end

  #
  # python-keyczar (for Accelerated Mode support)
  #
  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.8.tar.gz"
    sha256 "5d33be7ca0ec5997d76d29ea4c33b65c00c0231407fff975199d7f40530b8347"
  end

  resource "python-keyczar" do
    url "https://pypi.python.org/packages/source/p/python-keyczar/python-keyczar-0.715.tar.gz"
    sha256 "f43f9f15b0b719de94cab2754dcf78ef63b40ee2a12cea296e7af788b28501bb"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/source/p/passlib/passlib-1.6.4.tar.gz"
    sha256 "d41bd7a2d22f9bd7e19ff4eed0eea2316eb737f3ec6a7c361dde6b2785b08cdc"
  end

  #
  # shade (for OpenStack support)
  #
  resource "anyjson" do
    url "https://pypi.python.org/packages/source/a/anyjson/anyjson-0.3.3.tar.gz"
    sha256 "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba"
  end

  resource "appdirs" do
    url "https://pypi.python.org/packages/source/a/appdirs/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "bunch" do
    url "https://pypi.python.org/packages/source/b/bunch/bunch-1.0.1.tar.gz"
    sha256 "50c77a0fc0cb372dfe48b5e11937d5f70e743adbf42683f3a6d2857645a76aaa"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.1.2.tar.gz"
    sha256 "390970b602708c91ddc73953bb6929e56291c18a4d80f360afa00fad8b6f3339"
  end

  resource "cliff" do
    url "https://pypi.python.org/packages/source/c/cliff/cliff-1.13.0.tar.gz"
    sha256 "2b92d12cf1aa59c0cf1914b4b6b02b78daadac890a53d0e6b71b5220661ab9e0"
  end

  resource "cmd2" do
    url "https://pypi.python.org/packages/source/c/cmd2/cmd2-0.6.8.tar.gz"
    sha256 "ac780d8c31fc107bf6b4edcbcea711de4ff776d59d89bb167f8819d2d83764a8"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-0.9.3.tar.gz"
    sha256 "aed022f738dd9adb840d92960b0464ea1fbb222ba118938858eb93fe25151c2d"
  end

  resource "decorator" do
    url "https://pypi.python.org/packages/source/d/decorator/decorator-4.0.2.tar.gz"
    sha256 "1a089279d5de2471c47624d4463f2e5b3fc6a2cf65045c39bf714fc461a25206"
  end

  resource "dogpile" do
    url "https://pypi.python.org/packages/source/d/dogpile/dogpile-0.2.2.tar.gz"
    sha256 "bce7e7145054af20d4bef01c7b2fb4266fa88dca107ed246c395558a824e9bf0"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.6.tar.gz"
    sha256 "f80544c5555f66cf7b5fc99f15431f3b35f78009bc6b03b58fe1724236bbc57b"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
    sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
  end

  resource "functools32" do
    url "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.3.tar.gz"
    sha256 "2fe2342bb4fe8b8e217f0d21b5921cbe5408bf966d9f92025e707e881b198bed"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.14.tar.gz"
    sha256 "226f4be44c6cb64055e23060848266f51f329813baae28b53dc50e93488b3b3e"
  end

  resource "jsonpatch" do
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-1.11.tar.gz"
    sha256 "22d0bc0f5522a4a03dd9fb4c4cdf7c1f03256546c88be4c61e5ceabd22280e47"
  end

  resource "jsonpointer" do
    url "https://pypi.python.org/packages/source/j/jsonpointer/jsonpointer-1.9.tar.gz"
    sha256 "39403b47a71aa782de6d80db3b78f8a5f68ad8dfc9e674ca3bb5b32c15ec7308"
  end

  resource "jsonschema" do
    url "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "os-client-config" do
    url "https://pypi.python.org/packages/source/o/os-client-config/os-client-config-1.6.1.tar.gz"
    sha256 "24323a33fe4ec4ff0c71a91aa16d26f4c4320f0b0234c5ac22d08f99e2f5c24d"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.0.3.tar.gz"
    sha256 "06e729e1cbf5274703b1f47b6135ed8335999d547f9d8cf048b210fb8ebf844f"
  end

  resource "python-cinderclient" do
    url "https://pypi.python.org/packages/source/p/python-cinderclient/python-cinderclient-1.1.2.tar.gz"
    sha256 "d364b627fbcbd049b2cedf125fb6aa06e2ca6213208f92b7ea393a7e1d7ecbe2"
  end

  resource "python-glanceclient" do
    url "https://pypi.python.org/packages/source/p/python-glanceclient/python-glanceclient-0.19.0.tar.gz"
    sha256 "45115023cadfdbc24a10b10ca5d003f8f04fd5642b7c8fb565efa566bac4bf51"
  end

  resource "python-ironicclient" do
    url "https://pypi.python.org/packages/source/p/python-ironicclient/python-ironicclient-0.7.0.tar.gz"
    sha256 "2017670848153e8b7715d8704e8bf75bd262efa9b76a1aeb23ef26b0a2b58b12"
  end

  resource "python-neutronclient" do
    url "https://pypi.python.org/packages/source/p/python-neutronclient/python-neutronclient-2.6.0.tar.gz"
    sha256 "ce72506c0720825edcb0e93b643340e044f1de9235d398fe1c45d851971020df"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-2.5.0.tar.gz"
    sha256 "6efcbff0bf60521ef682068c10c2d8959d887f70ed84ccd2def9945e8e94560e"
  end

  resource "python-troveclient" do
    url "https://pypi.python.org/packages/source/p/python-troveclient/python-troveclient-1.2.0.tar.gz"
    sha256 "a0583f5b102953c433de01ef3b4964e78dab3f0a64c6dea5b0e09ef8e87d4b30"
  end

  resource "shade" do
    url "https://pypi.python.org/packages/source/s/shade/shade-0.11.0.tar.gz"
    sha256 "262acc863a34103a2416e54f3ee137de96f6e061bfebe53bdb0b19df5235c012"
  end

  resource "warlock" do
    url "https://pypi.python.org/packages/source/w/warlock/warlock-1.1.0.tar.gz"
    sha256 "bbfb4279034ccc402723e38d2a2e67cd619988bf4802fda7ba3e8fab15762651"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", share/"ansible"
      s.gsub! "/etc/ansible", etc/"ansible"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    man1.install Dir["docs/man/man1/*.1"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<-EOF.undent
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOF
    (testpath/"hosts.ini").write("localhost ansible_connection=local\n")
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"
  end
end
