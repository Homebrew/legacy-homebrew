class Subliminal < Formula
  homepage "https://subliminal.readthedocs.org"
  url "https://github.com/Diaoul/subliminal/archive/0.7.5.tar.gz"
  sha256 "ade34adc8085feba51cf056410e38bea0042e5956732e430baa5295e6522daa1"

  bottle do
    cellar :any
    revision 2
    sha256 "ef1e4c15582b72494950ceb7e28f03b558a54118b7177ced0c570bbe4d3d500a" => :yosemite
    sha256 "33f6267686fd0df0983dd7b0f1e795a190ad3a910fef1035f14f6bc4d42d1d3a" => :mavericks
    sha256 "b46b60fab3d228c3b36cf8ec653a8ede286e81534f87fa757b819df3f9979ba3" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "babelfish" do
    url "https://pypi.python.org/packages/source/b/babelfish/babelfish-0.5.4.tar.gz"
    sha256 "6e4f41f185b30b81232589c10b059546f3320cc440c5987f182ee82ab1778b47"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-6.0.8.tar.gz"
    sha256 "0d58487a1b7f5be2e5e965c11afbea1dc44ecec8069de03491a4d0d6c85f4551"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-0.10.8.tar.gz"
    sha256 "a741650c697abe9dd3da00039a57a45a15a6eed017a16f6b7e4c0161fae2b4b2"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "pysrt" do
    url "https://pypi.python.org/packages/source/p/pysrt/pysrt-1.0.1.tar.gz"
    sha256 "5300a1584c8d15a1c49ef8880fa1ef7a4274ce3f24dde83ad581d12d875f6784"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.6.tar.gz"
    sha256 "f80544c5555f66cf7b5fc99f15431f3b35f78009bc6b03b58fe1724236bbc57b"
  end

  resource "charade" do
    url "https://pypi.python.org/packages/source/c/charade/charade-1.0.3.tar.gz"
    sha256 "a607146d151005904f3fd8335e3dc89af214453f0d3a29580e1eb0e67e6c3d7f"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz"
    sha256 "a2b29bd048ca2fe54a046b29770964738872a9747003a371344a93eedf7ad58e"
  end

  resource "enzyme" do
    url "https://pypi.python.org/packages/source/e/enzyme/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "html5lib" do
    url "https://pypi.python.org/packages/source/h/html5lib/html5lib-0.999.tar.gz"
    sha256 "c3887f7e2875d7666107fa8bee761ff95b9391acdcc7cd1b5fd57a23b5fbc49e"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.3.0.tar.gz"
    sha256 "beab2b7f91966d259796392c39ed6f260b32851861561dd9f3b9be2fd0c426a5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.1.tar.gz"
    sha256 "23fd0a7c228d9c298c562245290a3f82999586c87aae71250f95f9894cb22c7c"
  end

  resource "guessit" do
    url "https://pypi.python.org/packages/source/g/guessit/guessit-0.9.4.tar.gz"
    sha256 "88689713946faad4ae12467dff40a8f3daa629200328fbc5256093e96b1b0d19"
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
    mkdir_p "#{ENV["HOME"]}/.config"
    system "#{bin}/subliminal", "-l", "en", "--", "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
  end
end
