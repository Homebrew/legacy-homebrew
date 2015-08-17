class Subliminal < Formula
  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.org"
  url "https://github.com/Diaoul/subliminal/archive/1.0.1.tar.gz"
  sha256 "b2db67d6a6d68c3fc5a2fda9ee5831879548c288af61de726cae508d72fc4816"
  head "https://github.com/Diaoul/subliminal.git"

  bottle do
    cellar :any
    sha256 "29d0af54b61269c0e371494ebb56429afc6a98e6e21423e692c25c367af2a07d" => :yosemite
    sha256 "8f3eff7ac992dce702753f2058c1c9513567658d2928e5dc82634db5f8df07cc" => :mavericks
    sha256 "419f7156a3b2cce921860d39dba17cdcb544b910c8223aa4e4fa1cf68a29950f" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.0.tar.gz"
    sha256 "d5275ba3221182a5dd1b6bcfbfc5ec277fb399dd23226d6fa018048f7e0f10f2"
  end

  resource "wsgiref" do
    url "https://pypi.python.org/packages/source/w/wsgiref/wsgiref-0.1.2.zip"
    sha256 "c7e610c800957046c04c8014aab8cce8f0b9f0495c8cd349e57c1f7cabf40e79"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "guessit" do
    url "https://pypi.python.org/packages/source/g/guessit/guessit-0.10.3.tar.gz"
    sha256 "d14ea0a2ea3413ec46119ea4d7a91b1f045761cfb3dc262c9dcd545742712dfe"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.6.tar.gz"
    sha256 "f80544c5555f66cf7b5fc99f15431f3b35f78009bc6b03b58fe1724236bbc57b"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.0.tar.gz"
    sha256 "fad91da88f69438b9ba939ab1b2cabaa31b1d914f1cccb4bb157a993ed2917f6"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.1.tar.gz"
    sha256 "e339ed09f25e2145314c902a870bc959adcb25653a2bd5cc1b48d9f56edf8ed8"
  end

  resource "enzyme" do
    url "https://pypi.python.org/packages/source/e/enzyme/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "pysrt" do
    url "https://pypi.python.org/packages/source/p/pysrt/pysrt-1.0.1.tar.gz"
    sha256 "5300a1584c8d15a1c49ef8880fa1ef7a4274ce3f24dde83ad581d12d875f6784"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.6.0.tar.gz"
    sha256 "dab2aa31ec742f651e6a2fe0429560aebbbe0fb7fc462fa0ff565c8f5ff2ec25"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "babelfish" do
    url "https://pypi.python.org/packages/source/b/babelfish/babelfish-0.5.4.tar.gz"
    sha256 "6e4f41f185b30b81232589c10b059546f3320cc440c5987f182ee82ab1778b47"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.3.0.tar.gz"
    sha256 "1a6f8d514fc11d2571c75c207d932c106f024f199b5f12d25f8ca022b026c59d"
  end

  resource "pyxdg" do
    url "https://pypi.python.org/packages/source/p/pyxdg/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "html5lib" do
    url "https://pypi.python.org/packages/source/h/html5lib/html5lib-0.999999.tar.gz"
    sha256 "e372b66f4997f8e1de970ea755d0a528d7222d2aa9bd55aac078c7ef39b8f6c3"
  end

  # not required by install_requires but provides additional UI when available
  resource "colorlog" do
    url "https://pypi.python.org/packages/source/c/colorlog/colorlog-2.6.0.tar.gz"
    sha256 "0f03ae0128a1ac2e22ec6a6617efbd36ab00d4b2e1c49c497e11854cf24f1fe9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # dogpile is a namespace package and .pth files aren't read from our
    # vendor site-packages
    touch libexec/"vendor/lib/python2.7/site-packages/dogpile/__init__.py"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    mkdir ".config"
    system "#{bin}/subliminal", "download", "-l", "en",
           "--", "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
  end
end
