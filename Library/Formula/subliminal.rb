class Subliminal < Formula
  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.org"
  url "https://github.com/Diaoul/subliminal/archive/0.7.5.tar.gz"
  sha256 "ade34adc8085feba51cf056410e38bea0042e5956732e430baa5295e6522daa1"
  head "https://github.com/Diaoul/subliminal.git"

  bottle do
    cellar :any
    revision 3
    sha256 "067176139576ba34459542202aa0e83496ae8a32a3c4e092f10a9314cb4fab60" => :yosemite
    sha256 "55c3722466c5247853420f55dee85c72567fc8672eb98a24647e5915a9087096" => :mavericks
    sha256 "9897cb9ccf97f15fb65fbd876b01a795d178e4282ef32a215714ad2675443d3e" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pyxdg" do
    url "https://pypi.python.org/packages/source/p/pyxdg/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

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
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
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
