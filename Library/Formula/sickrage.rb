class Sickrage < Formula
  desc "Automatic video library manager for TV Shows"
  homepage "https://www.sickrage.tv"
  url "https://pypi.python.org/packages/source/s/sickrage/sickrage-7.0.23.zip"
  sha256 "51c50799503bd86d0b0a03249b3e45819ae3a7198dfa3588d44ad24aae42d1f8"
  head "https://github.com/SiCKRAGETV/SickRage.git"

  bottle do
    cellar :any
    sha256 "94f6add1a3f4517b36f2f3861847922851cbb7657c89275d6aea53ab95fa0b70" => :el_capitan
    sha256 "0cb4b2f6e2d290a125737ba670267da20f3851a21677a39895038f18e14df051" => :yosemite
    sha256 "f3463916bf2cac143dbff400394f347f960d552cfbba36d5731677539245b71d" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  # needs a recent setuptools
  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-20.2.2.tar.gz"
    sha256 "24fcfc15364a9fe09a220f37d2dcedc849795e3de3e4b393ee988e66a9cbd85a"
  end

  resource "APScheduler" do
    url "https://pypi.python.org/packages/source/A/APScheduler/APScheduler-3.0.5.tar.gz"
    sha256 "009dcf552035b30ee967f2677d0d7a49a88f2d36291c42669aa069dd549da9e4"
  end

  resource "CacheControl" do
    url "https://pypi.python.org/packages/source/C/CacheControl/CacheControl-0.11.6.tar.gz"
    sha256 "37dfcb453e7f186c95b330834a1673e022db900d5e3a883f80257c4369477695"
  end

  resource "FormEncode" do
    url "https://pypi.python.org/packages/source/F/FormEncode/FormEncode-1.3.0.zip"
    sha256 "e6757280244a0d04e9cef51beeeafb4124087c27b7944c7d41341d0a30f7af78"
  end

  resource "Mako" do
    url "https://pypi.python.org/packages/source/M/Mako/Mako-1.0.3.tar.gz"
    sha256 "7644bc0ee35965d2e146dde31827b8982ed70a58281085fac42869a09764d38c"
  end

  resource "MultipartPostHandler" do
    url "https://pypi.python.org/packages/source/M/MultipartPostHandler/MultipartPostHandler-0.1.0.tar.gz"
    sha256 "d4c1823dc586d5507c0d269b763402311868b55236808d033d54300fa73e4a3d"
  end

  resource "PyGithub" do
    url "https://pypi.python.org/packages/source/P/PyGithub/PyGithub-1.26.0.tar.gz"
    sha256 "59d0ceafd1c4fb73117aa35f515988b691a386046714f278521ba01d260ddefb"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "SQLAlchemy" do
    url "https://pypi.python.org/packages/source/S/SQLAlchemy/SQLAlchemy-1.0.12.tar.gz"
    sha256 "6679e20eae780b67ba136a4a76f83bb264debaac2542beefe02069d0206518d1"
  end

  resource "SQLObject" do
    url "https://pypi.python.org/packages/source/S/SQLObject/SQLObject-3.0.0a2dev-20151224.tar.gz"
    sha256 "d48af6e351ba4036e3b2e1d47983758d4b6d924d2a5eb28299bb04d4a70bd809"
  end

  resource "Send2Trash" do
    url "https://pypi.python.org/packages/source/S/Send2Trash/Send2Trash-1.3.0.tar.gz"
    sha256 "33f4461eae831eb09a21b70ca202c2a6dfd83db6bafa1e1ca11b5001e22c58fe"
  end

  resource "Tempita" do
    url "https://pypi.python.org/packages/source/T/Tempita/Tempita-0.5.3dev.tar.gz"
    sha256 "38392bb708a10128419f75fa9120a6d2c8d137013b353968e5008a77a5c7a2ca"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "babelfish" do
    url "https://pypi.python.org/packages/source/b/babelfish/babelfish-0.5.5.tar.gz"
    sha256 "8380879fa51164ac54a3e393f83c4551a275f03617f54a99d70151358e444104"
  end

  resource "backport_ipaddress" do
    url "https://pypi.python.org/packages/source/b/backport_ipaddress/backport_ipaddress-0.1.tar.gz"
    sha256 "860e338c08e2e9d998ed8434e944af9780e2baa337d1544cc26c9b1763b7735c"
  end

  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "bencode" do
    url "https://pypi.python.org/packages/source/b/bencode/bencode-1.0.tar.gz"
    sha256 "0301c2202233a3f274c940702bac7bd02d5d053b8bf9502b085156270e30be9b"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2016.2.28.tar.gz"
    sha256 "5e8eccf95924658c97b990b50552addb64f55e1e3dfe4880456ac1f287dc79d0"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.2.tar.gz"
    sha256 "da9bde99872e46f7bb5cff40a9b1cc08406765efafb583c704de108b6cb821dd"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.3.tar.gz"
    sha256 "b720d9faabe193287b71e3c26082b0f249501288e153b7e7cfce3bb87ac8cc1c"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.2.3.tar.gz"
    sha256 "8eb11c77dd8e73f48df6b2f7a7e16173fe0fe8fdfe266232832e88477e08454e"
  end

  resource "decorator" do
    url "https://pypi.python.org/packages/source/d/decorator/decorator-4.0.9.tar.gz"
    sha256 "90022e83316363788a55352fe39cfbed357aa3a71d90e5f2803a35471de4bba8"
  end

  resource "dill" do
    url "https://pypi.python.org/packages/source/d/dill/dill-0.2.5.tgz"
    sha256 "431c9d46e190dcdf1397234cf659d66e2e22e33b0474ed6ee2d0b16c9c0ea319"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.7.tar.gz"
    sha256 "dcf99b09ddf3d8216b1b4378100eb0235619612fb0e6300ba5d74f10962d0956"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
  end

  resource "enzyme" do
    url "https://pypi.python.org/packages/source/e/enzyme/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "feedparser" do
    url "https://pypi.python.org/packages/source/f/feedparser/feedparser-5.2.1.tar.bz2"
    sha256 "ce875495c90ebd74b179855449040003a1beb40cd13d5f037a0654251e260b02"
  end

  resource "future" do
    url "https://pypi.python.org/packages/source/f/future/future-0.15.2.tar.gz"
    sha256 "3d3b193f20ca62ba7d8782589922878820d0a023b885882deec830adbf639b97"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "gntp" do
    url "https://pypi.python.org/packages/source/g/gntp/gntp-1.0.2.tar.gz"
    sha256 "8b94a071deca2a1d24825620bf781e6261e1587bc9c401c7c7258abed934fc78"
  end

  resource "guessit" do
    url "https://pypi.python.org/packages/source/g/guessit/guessit-2.0.4.tar.gz"
    sha256 "4f72e21fca9c294651abee26554e2ad778220d90a84f6e1195299a7ec17accb1"
  end

  resource "hachoir-core" do
    url "https://pypi.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-metadata" do
    url "https://pypi.python.org/packages/source/h/hachoir-metadata/hachoir-metadata-1.3.3.tar.gz"
    sha256 "ec403f13a44e2cf3d26001f8f440cdc4329a316a4c971035944bfadacc90eb3c"
  end

  resource "hachoir-parser" do
    url "https://pypi.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "html5lib" do
    url "https://pypi.python.org/packages/source/h/html5lib/html5lib-1.0b8.tar.gz"
    sha256 "18f4d63fa56836e3d62e96a44d06fcfe01a9be397a222368ee21403b64c176d2"
  end

  resource "httplib2" do
    url "https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "imdbpie" do
    url "https://pypi.python.org/packages/source/i/imdbpie/imdbpie-4.0.2.tar.gz"
    sha256 "95d2fe0f56a636dcfd1e8ad40d8bb458b8a3db2aa0d7a53d466fe16670e71e30"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "jsonrpclib" do
    url "https://pypi.python.org/packages/source/j/jsonrpclib/jsonrpclib-0.1.7.tar.gz"
    sha256 "7f50239d53b5e95b94455d5e1adae70592b5b71f0e960d3bbbfbb125788e6f0b"
  end

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "markdown2" do
    url "https://pypi.python.org/packages/source/m/markdown2/markdown2-2.3.0.zip"
    sha256 "c8e29ba47a0e408bb92df75d5c6361c84268c54c5320d53ffd4961c546f77f1c"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/source/n/ndg-httpsclient/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "oauth2" do
    url "https://pypi.python.org/packages/source/o/oauth2/oauth2-1.9.0.post1.tar.gz"
    sha256 "c006a85e7c60107c7cc6da1b184b5c719f6dd7202098196dfa6e55df669b59bf"
  end

  resource "oauthlib" do
    url "https://pypi.python.org/packages/source/o/oauthlib/oauthlib-1.0.3.tar.gz"
    sha256 "ef4bfe4663ca3b97a995860c0173b967ebd98033d02f38c9e1b2cbb6c191d9ad"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.8.1.tar.gz"
    sha256 "e2127626a91e6c885db89668976db31020f0af2da728924b56480fc7ccf09649"
  end

  resource "profilehooks" do
    url "https://pypi.python.org/packages/source/p/profilehooks/profilehooks-1.8.1.tar.gz"
    sha256 "f5a755cc4f3280c931f6598d14ea99844a7fc08faff49d876af28bbccd139f13"
  end

  resource "py-unrar2" do
    url "https://pypi.python.org/packages/source/p/py-unrar2/py-unrar2-0.99.6.tar.gz"
    sha256 "1aa6c67870a60224baea9fc8dbd72ad0bd1452ca4c90415bf54768e1463002bb"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pysrt" do
    url "https://pypi.python.org/packages/source/p/pysrt/pysrt-1.0.1.tar.gz"
    sha256 "5300a1584c8d15a1c49ef8880fa1ef7a4274ce3f24dde83ad581d12d875f6784"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.5.0.tar.gz"
    sha256 "c1f7a66b0021bd7b206cc60dd47ecc91b931cdc5258972dc56b25186fa9a96a5"
  end

  resource "python-fanart" do
    url "https://pypi.python.org/packages/source/p/python-fanart/python-fanart-1.4.0.tar.gz"
    sha256 "321cabadad4c38b8b761c1ac2a89a0e44b9bcc6bb0d712842409710eaab2cc41"
  end

  resource "python-twitter" do
    url "https://pypi.python.org/packages/source/p/python-twitter/python-twitter-3.0rc1.tar.gz"
    sha256 "925ec4aa9df7ffff6759b46d33f43806e26c84e2e81dba377a13a4891555d984"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.bz2"
    sha256 "fbd26746772c24cb93c8b97cbdad5cb9e46c86bbdb1b9d8a743ee00e2fb1fc5d"
  end

  resource "pyxdg" do
    url "https://pypi.python.org/packages/source/p/pyxdg/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requests-oauthlib" do
    url "https://pypi.python.org/packages/source/r/requests-oauthlib/requests-oauthlib-0.6.1.tar.gz"
    sha256 "905306080ec0cc6b3c65c8101f471fccfdb9994c16dd116524fd3fc0790d46d7"
  end

  resource "rtorrent-python" do
    url "https://pypi.python.org/packages/source/r/rtorrent-python/rtorrent-python-0.2.9.tar.gz"
    sha256 "d42e10e92683601280fca0534086424f9e1eaaf8a1c74bf2d3553093eed68735"
  end

  resource "simplejson" do
    url "https://pypi.python.org/packages/source/s/simplejson/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sqlalchemy-migrate" do
    url "https://pypi.python.org/packages/source/s/sqlalchemy-migrate/sqlalchemy-migrate-0.10.0.tar.gz"
    sha256 "f83c5cce9c09e5c05527279b7fe1565b32e5353342ff30b24f594fa2e5a7e003"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.18.tar.gz"
    sha256 "39b196c4a06f76d6ac82f029457ca961f662a8bbbb2694eb1dfe4f2b68a2d7cf"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.12.0.tar.gz"
    sha256 "1bdeb2562d8f2c1e3047c2f17134a38b37a6e53e16ca1d9f79ff2ac5d5fe2925"
  end

  resource "subliminal" do
    url "https://pypi.python.org/packages/source/s/subliminal/subliminal-1.1.1.tar.gz"
    sha256 "ab50cff2dcdc4c302f11074d22b2aa8b1c12bbd13e81ee7ad362947a18ad3fca"
  end

  resource "sympy" do
    url "https://pypi.python.org/packages/source/s/sympy/sympy-0.7.6.1.tar.gz"
    sha256 "1fc272b51091aabe7d07f1bf9f0a47f3e28657fb2bec52bf3ef0e8f159f5f564"
  end

  resource "tmdbsimple" do
    url "https://pypi.python.org/packages/source/t/tmdbsimple/tmdbsimple-1.3.0.tar.gz"
    sha256 "57127371cf8f19fd2fbfa790429f063e4304b3532392d9a1b8f7bc40b0657fd5"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  resource "tzlocal" do
    url "https://pypi.python.org/packages/source/t/tzlocal/tzlocal-1.2.2.tar.gz"
    sha256 "cbbaa4e9d25c36386f12af9febe315139fdd39317b91abcb42d782a5e93e525d"
  end

  resource "xmltodict" do
    url "https://pypi.python.org/packages/source/x/xmltodict/xmltodict-0.10.1.tar.gz"
    sha256 "b2cab0184bbb8c3627fc54b03ed79ea2f4d5579fa041e3456ff8d3b3c09b0d5e"
  end

  resource "yarg" do
    url "https://pypi.python.org/packages/source/y/yarg/yarg-0.1.9.tar.gz"
    sha256 "55695bf4d1e3e7f756496c36a69ba32c40d18f821e38f61d028f6049e5e15911"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    libexec.install Dir["*"]

    (bin/"sickrage").write <<-EOS.undent
      #!/bin/bash
      export PYTHONPATH="#{libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"
      python "#{libexec}/SickBeard.py"\
        "--pidfile=#{var}/run/sickrage.pid"\
        "--datadir=#{etc}/sickrage"\
        "$@"
    EOS
  end

  plist_options :manual => "sickrage"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/sickrage</string>
        <string>-q</string>
        <string>--nolaunch</string>
        <string>-p</string>
        <string>8081</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match /SickBeard\.py/, shell_output("#{bin}/sickrage --help 2>&1", 1)
  end
end
