class Ansible < Formula
  desc "Automate deployment, configuration, and upgrading"
  homepage "http://www.ansible.com"
  url "https://releases.ansible.com/ansible/ansible-2.0.0.2.tar.gz"
  sha256 "27db0b99113fab85b1430c361c7790a0aa7f5c614c9af13362e2adbba07e5828"

  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    sha256 "e908352026258a071fb6ba09a2b08d1d11fa4b600d1cdfe9fd2a2788acfcb645" => :el_capitan
    sha256 "2f10a4dec3d5a34c84e6bfaecdee4670311ca6fd56a7a5e86237eaedad1bb491" => :yosemite
    sha256 "d556b7e2a0fcd0a58d3b1f86ed299fc052199c0de541bbef23007c3ddb93c6b3" => :mavericks
  end

  devel do
    url "https://releases.ansible.com/ansible/ansible-2.0.1.0-0.1.rc1.tar.gz"
    sha256 "ab2230f22d742e1379c72a3a59b18779a6aad2b4db69e87e073478028f51b24b"
    version "2.0.1.0-0.1.rc1"
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
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.16.0.tar.gz"
    sha256 "3297ebd3cd072f573772f7c7426939a443c62c458d54bb632ff30fd6ecf96892"
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
  # See https://docs.ansible.com/uri_module.html#requirements)
  #
  resource "httplib2" do
    url "https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  #
  # Resources required by docker-py, pyrax, and shade (see below).
  # Install requests with [security]
  #
  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.4.2.tar.gz"
    sha256 "8f1d177d364ea35900415ae24ca3e471be3d5334ed0419294068c49f45913998"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.1.2.tar.gz"
    sha256 "7f51459f84d670444275e615839f4542c93547a12e938a0a4906dafe5f7de153"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/source/n/ndg-httpsclient/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  #
  # docker-py (for Docker support)
  #
  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.5.0.tar.gz"
    sha256 "6924128fac46afef0de16ebdffc30a8c071246312260f289d895129f4e00f8d0"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket_client-0.34.0.tar.gz"
    sha256 "682a6241ca953499f06ca506f69aa3ea26f0ed2a41fe7982732cb8449ae92ddf"
  end

  #
  # pywinrm (for Windows support)
  #
  resource "isodate" do
    url "https://pypi.python.org/packages/source/i/isodate/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  resource "pywinrm" do
    url "https://pypi.python.org/packages/source/p/pywinrm/pywinrm-0.1.1.tar.gz"
    sha256 "0230d7e574a5375e8a0b46001a2bce2440aba2b866629342be0360859f8d514d"
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
  # boto/boto3 (for AWS support)
  #
  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  resource "boto3" do
    url "https://pypi.python.org/packages/source/b/boto3/boto3-1.2.3.tar.gz"
    sha256 "091206847d296520e5ec57706a5e4b428d017352eb3168c6bcb9a1ac9feab224"
  end

  #
  # Required by the 'boto3' module
  # https://github.com/boto/boto3
  #
  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.3.17.tar.gz"
    sha256 "1ca85c5ebe0beed7b54fc47de81d3f39c6bb907951fe6db6a38185de63db7723"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  #
  # pyrax (for Rackspace support)
  #
  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.1.1.tar.gz"
    sha256 "7fb6d50effe88a087feb2036cb972fd7a893bf338361516f1a55a820bf7b5248"
  end

  resource "debtcollector" do
    url "https://pypi.python.org/packages/source/d/debtcollector/debtcollector-0.10.0.tar.gz"
    sha256 "8cc22cf2223af7789692ef0b1cb5c0c3a00da7d6e34cbfce125a956cb4d2f21e"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/source/f/funcsigs/funcsigs-0.4.tar.gz"
    sha256 "d83ce6df0b0ea6618700fe1db353526391a8a3ada1b7aba52fed7a61da772033"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/i/ip_associations_python_novaclient_ext/ip_associations_python_novaclient_ext-0.1.tar.gz"
    sha256 "a709b8804364afbbab81470b57e8df3f3ea11dff843c6cb4590bbc130cea94f7"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-5.6.tar.gz"
    sha256 "862e8c7ae689bd1e50bf5940c88317c3afad4b71d7c0e0748b273ef769c66adf"
  end

  resource "mock" do
    # NOTE: mock versions above 1.0.1 fail to install due to a broken setuptools version check.
    url "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha256 "b839dd2d9c117c701430c149956918a423a9863b48b09c90e30a6013e7d2f44f"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/source/m/monotonic/monotonic-0.4.tar.gz"
    sha256 "852f656adbf623ee859def6ca2f5498f4cae3256f8320d5c50570ee8a0592ab6"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
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
    url "https://pypi.python.org/packages/source/o/oslo.config/oslo.config-2.6.0.tar.gz"
    sha256 "5d5f1cba6c6175a4222d71ae9aac031054c79529b67cb5e43cb627e8837a9ee5"
  end

  resource "oslo.i18n" do
    url "https://pypi.python.org/packages/source/o/oslo.i18n/oslo.i18n-2.7.0.tar.gz"
    sha256 "9f510fd251510ca670ef876783a1727f67fe7a27595d772057273d33e4664f86"
  end

  resource "oslo.serialization" do
    url "https://pypi.python.org/packages/source/o/oslo.serialization/oslo.serialization-1.11.0.tar.gz"
    sha256 "b9a5b8bd4583957476464016f1c4d3ca01a30a0125acb1cd0ddd830715c88e1f"
  end

  resource "oslo.utils" do
    url "https://pypi.python.org/packages/source/o/oslo.utils/oslo.utils-2.7.0.tar.gz"
    sha256 "5afed9470494222bc6d90efddfc52223cfc84e03a3898775a7a7ee44a4e7e424"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.8.1.tar.gz"
    sha256 "e2127626a91e6c885db89668976db31020f0af2da728924b56480fc7ccf09649"
  end

  resource "PrettyTable" do
    url "https://pypi.python.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pyrax" do
    url "https://pypi.python.org/packages/source/p/pyrax/pyrax-1.9.5.tar.gz"
    sha256 "59ac98ae0549beb1eb36cc1f4985d565f126adbfa596d7fa5aaccde5ef194c0e"
  end

  resource "python-keystoneclient" do
    url "https://pypi.python.org/packages/source/p/python-keystoneclient/python-keystoneclient-1.8.1.tar.gz"
    sha256 "4429b973fc45636d1f7117791d930391a432b4d0db76eafb75f918a8e6d68cf0"
  end

  resource "python-novaclient" do
    url "https://pypi.python.org/packages/source/p/python-novaclient/python-novaclient-2.34.0.tar.gz"
    sha256 "62c0d1996b2eb53707c3bef7a445a05a809d427c92a2030ed95b59f49031e527"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.bz2"
    sha256 "fbd26746772c24cb93c8b97cbdad5cb9e46c86bbdb1b9d8a743ee00e2fb1fc5d"
  end

  resource "rackspace-auth-openstack" do
    url "https://pypi.python.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://pypi.python.org/packages/source/r/rackspace-novaclient/rackspace-novaclient-1.5.tar.gz"
    sha256 "0fcde7e22594d9710c65e850d11898bd342fa83849dc8ef32c2a94117f7132b1"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-0.3.2.tar.gz"
    sha256 "bf18d534f6ab1ca1c82680a71d631babee285257c7d99321413a19d773790915"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://pypi.python.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.1.tar.gz"
    sha256 "428ac8f3219c78fb04ce05895d5dff9bd813c05a9a7922c53dc879cd32a12493"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.9.0.tar.gz"
    sha256 "cc19908840498ed5f7cb5cf59bbe47b41aa9d65821548e2b3c8a99a571cbec06"
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

  # also required by the htpasswd core module
  resource "passlib" do
    url "https://pypi.python.org/packages/source/p/passlib/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
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

  resource "cliff" do
    url "https://pypi.python.org/packages/source/c/cliff/cliff-1.15.0.tar.gz"
    sha256 "f5ba6fe0940547549947d5a24ca3354145a603d3a9ba054f209d20b66dc02be7"
  end

  resource "cmd2" do
    url "https://pypi.python.org/packages/source/c/cmd2/cmd2-0.6.8.tar.gz"
    sha256 "ac780d8c31fc107bf6b4edcbcea711de4ff776d59d89bb167f8819d2d83764a8"
  end

  resource "decorator" do
    url "https://pypi.python.org/packages/source/d/decorator/decorator-4.0.4.tar.gz"
    sha256 "5ad0c10fad31648cffa15ee0640eee04bbb1b843a02de26ad3700740768cc3e1"
  end

  resource "dogpile" do
    url "https://pypi.python.org/packages/source/d/dogpile/dogpile-0.2.2.tar.gz"
    sha256 "bce7e7145054af20d4bef01c7b2fb4266fa88dca107ed246c395558a824e9bf0"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.7.tar.gz"
    sha256 "dcf99b09ddf3d8216b1b4378100eb0235619612fb0e6300ba5d74f10962d0956"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
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
    url "https://pypi.python.org/packages/source/j/jsonpatch/jsonpatch-1.12.tar.gz"
    sha256 "2e1eb457f9c8dd5dae837ca93c0fe5bd2522c9d44b9b380fb1aab2ab4dec04b1"
  end

  resource "jsonpointer" do
    url "https://pypi.python.org/packages/source/j/jsonpointer/jsonpointer-1.10.tar.gz"
    sha256 "9fa5dcac35eefd53e25d6cd4c310d963c9f0b897641772cd6e5e7b89df7ee0b1"
  end

  resource "jsonschema" do
    url "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keystoneauth1" do
    url "https://pypi.python.org/packages/source/k/keystoneauth1/keystoneauth1-1.2.0.tar.gz"
    sha256 "e8386dc8b0f17d439e1f2f4e6a8ef64fe0f2b81938b2f0b13f80042bb98e2b85"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "munch" do
    url "https://pypi.python.org/packages/source/m/munch/munch-2.0.4.tar.gz"
    sha256 "1420683a94f3a2ffc77935ddd28aa9ccb540dd02b75e02ed7ea863db437ab8b2"
  end

  resource "os-client-config" do
    url "https://pypi.python.org/packages/source/o/os-client-config/os-client-config-1.10.2.tar.gz"
    sha256 "b0e24a97224469ad814d933d55d575678c0e26d633918844e8b7338fce631841"
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
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.0.5.tar.gz"
    sha256 "58756bf33e989d84ac72142e4ca558cf10c778a3233edb0a86632f271409ba9e"
  end

  resource "python-cinderclient" do
    url "https://pypi.python.org/packages/source/p/python-cinderclient/python-cinderclient-1.1.2.tar.gz"
    sha256 "d364b627fbcbd049b2cedf125fb6aa06e2ca6213208f92b7ea393a7e1d7ecbe2"
  end

  resource "python-designateclient" do
    url "https://pypi.python.org/packages/source/p/python-designateclient/python-designateclient-1.5.0.tar.gz"
    sha256 "bbd93cca7eb966a270b5c49247b12fb2bf8fbb80a8577574d5c1bc8812de9cf2"
  end

  resource "python-glanceclient" do
    url "https://pypi.python.org/packages/source/p/python-glanceclient/python-glanceclient-1.1.0.tar.gz"
    sha256 "59ff30927468215131a68ffbfb9b2cb15d636a17cf702d87d0370957b553f25e"
  end

  resource "python-heatclient" do
    url "https://pypi.python.org/packages/source/p/python-heatclient/python-heatclient-0.8.0.tar.gz"
    sha256 "5cd1c855ee21f18bfffbc7269e40c417b953d0855aa3cc8b56d778b8612467d5"
  end

  resource "python-ironicclient" do
    url "https://pypi.python.org/packages/source/p/python-ironicclient/python-ironicclient-0.10.0.tar.gz"
    sha256 "53259ad9fc3b2d4a38b61ded24e89ca226e91c700daae1d9639251a20b6c7990"
  end

  resource "python-neutronclient" do
    url "https://pypi.python.org/packages/source/p/python-neutronclient/python-neutronclient-3.1.0.tar.gz"
    sha256 "02c432b35806f4017c9041ac609a367e0423973cdb48706c3c807c8a56e9263d"
  end

  resource "python-openstackclient" do
    url "https://pypi.python.org/packages/source/p/python-openstackclient/python-openstackclient-1.8.0.tar.gz"
    sha256 "d71369f802d8d537efc576acc437465d636e1aadc20f011e6bbdc38597db5258"
  end

  resource "python-swiftclient" do
    url "https://pypi.python.org/packages/source/p/python-swiftclient/python-swiftclient-2.6.0.tar.gz"
    sha256 "f7344b2a66ec0518d97e262a083b7e30e41fc0eb8e50661dd300e29d3ea163c8"
  end

  resource "python-troveclient" do
    url "https://pypi.python.org/packages/source/p/python-troveclient/python-troveclient-1.4.0.tar.gz"
    sha256 "990c8d6b8b506ce35b883290d59932b6d08e8367f990bc3d365d659cfa9c2b51"
  end

  resource "shade" do
    url "https://pypi.python.org/packages/source/s/shade/shade-1.0.0.tar.gz"
    sha256 "40403c7be65971581027b248e504f3ba8a2e250f03b9f315d87a8eeb402429ab"
  end

  resource "unicodecsv" do
    url "https://pypi.python.org/packages/source/u/unicodecsv/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "warlock" do
    url "https://pypi.python.org/packages/source/w/warlock/warlock-1.2.0.tar.gz"
    sha256 "7c0d17891e14cf77e13a598edecc9f4682a5bc8a219dc84c139c5ba02789ef5a"
  end

  def install
    vendor_site_packages = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # ndg is a namespace package
    touch vendor_site_packages/"ndg/__init__.py"

    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", pkgshare
      s.gsub! "/etc/ansible", etc/"ansible"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    man1.install Dir["docs/man/man1/*.1"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    Homebrew writes wrapper scripts that set PYTHONPATH in ansible's
    execution environment, which is inherited by Python scripts invoked
    by ansible. If this causes problems, you can modify your playbooks
    to invoke python with -E, which causes python to ignore PYTHONPATH.
    EOS
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
    (testpath/"hosts.ini").write "localhost ansible_connection=local\n"
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"
  end
end
