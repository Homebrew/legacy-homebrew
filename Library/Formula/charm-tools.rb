class CharmTools < Formula
  desc "Tools for authoring and maintaining juju charms"
  homepage "https://github.com/juju/charm-tools"
  url "https://github.com/juju/charm-tools/releases/download/v1.11.1/charm-tools-1.11.1.tar.gz"
  sha256 "e6172443101134fffadf0e4953379f28a5343d77df9e8891d51199bc0fd9f745"

  bottle do
    cellar :any
    sha256 "c9e61aaba48e5818ef30c6f96a83e8696a5d6fc26dbd7340d1117b21b957c418" => :el_capitan
    sha256 "6565eb34207ca596a3a6327ed58cab25f1516942c2a6a25573c53263f4632a09" => :yosemite
    sha256 "75fae4ac99c2a97e4b9af6b7d526b84a4b3b39c1aebbd0d00aa9ebc25718f885" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on :hg

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
    sha256 "ca047986f0528cfa975a14fb9f7f106271d4e0c3fe1ddced6c1db2e7ae57a477"
  end

  resource "blessings" do
    url "https://pypi.python.org/packages/source/b/blessings/blessings-1.6.tar.gz"
    sha256 "edc5713061f10966048bf6b40d9a514b381e0ba849c64e034c4ef6c1847d3007"
  end

  resource "bzr" do
    url "https://pypi.python.org/packages/source/b/bzr/bzr-2.6.0.tar.gz"
    sha256 "0994797182eb828867eee81cccc79480bd2946c99304266bc427b902cf91dab0"
  end

  resource "charm-tools" do
    url "https://pypi.python.org/packages/source/c/charm-tools/charm-tools-1.9.2.tar.gz"
    sha256 "2a1c8b0066d3f6c527d6b8d273c7def20800f7539d4c82488c84d97f92364161"
  end

  resource "charmworldlib" do
    url "https://pypi.python.org/packages/source/c/charmworldlib/charmworldlib-0.4.2.tar.gz"
    sha256 "bdcd0ef5e53603a3bca83d9eca7077be4d798a61325baffeab5b2267ba69bd77"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "colander" do
    url "https://pypi.python.org/packages/source/c/colander/colander-1.0.tar.gz"
    sha256 "7389413266b9e680c9529c16d56284edf87e0d5de557948e75f41d65683c23b3"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "httplib2" do
    url "https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  resource "iso8601" do
    url "https://pypi.python.org/packages/source/i/iso8601/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "jsonschema" do
    url "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "jujubundlelib" do
    url "https://pypi.python.org/packages/source/j/jujubundlelib/jujubundlelib-0.3.1.tar.gz"
    sha256 "23941e8558e49b971a4500abe23bd29abca12a8ccbfe2e1aa0ab9fe4490743f4"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-5.6.tar.gz"
    sha256 "862e8c7ae689bd1e50bf5940c88317c3afad4b71d7c0e0748b273ef769c66adf"
  end

  resource "launchpadlib" do
    url "https://pypi.python.org/packages/source/l/launchpadlib/launchpadlib-1.10.3.tar.gz"
    sha256 "741ca0080dfa8b307db2d89c6050c41d975d96160419b3292b19443ce656ef6b"
  end

  resource "lazr.authentication" do
    url "https://pypi.python.org/packages/source/l/lazr.authentication/lazr.authentication-0.1.3.tar.gz"
    sha256 "23b66ba6a135168e22e0142f9c18b5fa3c1ed37b08c6ef71c8acd7adb244fa11"
  end

  resource "lazr.restfulclient" do
    url "https://pypi.python.org/packages/source/l/lazr.restfulclient/lazr.restfulclient-0.13.1.tar.gz"
    sha256 "0b678412b61e3f9722525c07f7bbfd3a15173c3869d3dab30f2671c9bead7f2a"
  end

  resource "lazr.uri" do
    url "https://pypi.python.org/packages/source/l/lazr.uri/lazr.uri-1.0.3.tar.gz"
    sha256 "5c620b5993c8c6a73084176bfc51de64972b8373620476ed841931a49752dc8b"
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.4.tar.gz"
    sha256 "e436eee7aaf2a230ca3315034dd39e8a0fc27036708acaa3dd70625ec62a94ce"
  end

  resource "oauth" do
    url "https://pypi.python.org/packages/source/o/oauth/oauth-1.0.1.tar.gz"
    sha256 "e769819ff0b0c043d020246ce1defcaadd65b9c21d244468a45a7f06cb88af5d"
  end

  resource "otherstuf" do
    url "https://pypi.python.org/packages/source/o/otherstuf/otherstuf-1.1.0.tar.gz"
    sha256 "7722980c3b58845645da2acc838f49a1998c8a6bdbdbb1ba30bcde0b085c4f4c"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.16.0.tar.gz"
    sha256 "3297ebd3cd072f573772f7c7426939a443c62c458d54bb632ff30fd6ecf96892"
  end

  resource "parse" do
    url "https://pypi.python.org/packages/source/p/parse/parse-1.6.6.tar.gz"
    sha256 "71435aaac494e08cec76de646de2aab8392c114e56fe3f81c565ecc7eb886178"
  end

  resource "path.py" do
    url "https://pypi.python.org/packages/source/p/path.py/path.py-8.1.2.tar.gz"
    sha256 "ada95d117c4559abe64080961daf5badda68561afdd34c278f8ca20f2fa466d2"
  end

  resource "pathspec" do
    url "https://pypi.python.org/packages/source/p/pathspec/pathspec-0.3.4.tar.gz"
    sha256 "7605ca5c26f554766afe1d177164a2275a85bb803b76eba3428f422972f66728"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.8.1.tar.gz"
    sha256 "84fe8d5bf4dcdcc49002446c47a146d17ac10facf00d9086659064ac43b6c25b"
  end

  resource "ruamel.base" do
    url "https://pypi.python.org/packages/source/r/ruamel.base/ruamel.base-1.0.0.tar.gz"
    sha256 "c041333a0f0f00cd6593eb36aa83abb1a9e7544e83ba7a42aa7ac7476cee5cf3"
  end

  resource "ruamel.ordereddict" do
    url "https://pypi.python.org/packages/source/r/ruamel.ordereddict/ruamel.ordereddict-0.4.9.tar.gz"
    sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "ruamel.yaml" do
    url "https://pypi.python.org/packages/source/r/ruamel.yaml/ruamel.yaml-0.10.12.tar.gz"
    sha256 "2bfd7d00c0ca859dbf1a7abca79969eedd25c76a976b7d40f94e1891a6e73f2c"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.1.tar.gz"
    sha256 "428ac8f3219c78fb04ce05895d5dff9bd813c05a9a7922c53dc879cd32a12493"
  end

  resource "stuf" do
    url "https://pypi.python.org/packages/source/s/stuf/stuf-0.9.16.tar.bz2"
    sha256 "e61d64a2180c19111e129d36bfae66a0cb9392e1045827d6495db4ac9cb549b0"
  end

  resource "testresources" do
    url "https://pypi.python.org/packages/source/t/testresources/testresources-0.2.7.tar.gz"
    sha256 "ad0a117383dd463827b199eaa92829b4d6a3147fbd97459820df53bae81d7231"
  end

  resource "translationstring" do
    url "https://pypi.python.org/packages/source/t/translationstring/translationstring-1.3.tar.gz"
    sha256 "4ee44cfa58c52ade8910ea0ebc3d2d84bdcad9fa0422405b1801ec9b9a65b72d"
  end

  resource "virtualenv" do
    url "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz"
    sha256 "aabc8ef18cddbd8a2a9c7f92bc43e2fea54b1147330d65db920ef3ce9812e3dc"
  end

  resource "wadllib" do
    url "https://pypi.python.org/packages/source/w/wadllib/wadllib-1.3.2.tar.gz"
    sha256 "140e43fc16d4352a98a90a450c6326bee5e6de73ae373a569947f3b505405034"
  end

  resource "wsgi_intercept" do
    url "https://pypi.python.org/packages/source/w/wsgi_intercept/wsgi_intercept-0.10.3.tar.gz"
    sha256 "19406458175da02999f228b4abbdd68561dd22abe0088228ae6171cf1464ce77"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.3.tar.gz"
    sha256 "2e221a9eec7ccc58889a278ea13dcfed5ef939d80b07819a9a8b3cb1c681484f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pip blessings bzr charm-tools charmworldlib Cheetah colander ecdsa httplib2 iso8601 jsonschema jujubundlelib keyring launchpadlib lazr.authentication lazr.restfulclient lazr.uri Markdown oauth otherstuf paramiko parse path.py pathspec pycrypto PyYAML requests ruamel.base ruamel.ordereddict ruamel.yaml simplejson stuf testresources translationstring virtualenv wadllib wsgi_intercept zope.interface].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*charm*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/charm", "list"
  end
end
