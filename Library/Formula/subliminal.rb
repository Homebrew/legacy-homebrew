class Subliminal < Formula
  desc "Library to search and download subtitles"
  homepage "https://subliminal.readthedocs.org"
  url "https://github.com/Diaoul/subliminal/archive/1.1.1.tar.gz"
  sha256 "fd02eec1206ab1ef0ce83b0e051b3e029d90348f7a06461b9b6cdc681cea7de6"
  head "https://github.com/Diaoul/subliminal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4d0d304782b21842a0f7e7fefbadb32ab982de1a4fcc20f13f1ee239e54d9f2" => :el_capitan
    sha256 "39ab0aadf43fab57da319cd085b337ea9bee39f140e9a2480b62832911eee2ba" => :yosemite
    sha256 "e66dd3db034b87891a26548facba96ccbe6aa99e0f1294137ff52439769b641a" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
    sha256 "ca047986f0528cfa975a14fb9f7f106271d4e0c3fe1ddced6c1db2e7ae57a477"
  end

  resource "babelfish" do
    url "https://pypi.python.org/packages/source/b/babelfish/babelfish-0.5.5.tar.gz"
    sha256 "8380879fa51164ac54a3e393f83c4551a275f03617f54a99d70151358e444104"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.2.tar.gz"
    sha256 "fba0ff70f5ebb4cebbf64c40a8fbc222fb7cf825237241e548354dabe3da6a82"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.7.tar.gz"
    sha256 "dcf99b09ddf3d8216b1b4378100eb0235619612fb0e6300ba5d74f10962d0956"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "enzyme" do
    url "https://pypi.python.org/packages/source/e/enzyme/enzyme-0.4.1.tar.gz"
    sha256 "f2167fa97c24d1103a94d4bf4eb20f00ca76c38a37499821049253b2059c62bb"
  end

  resource "guessit" do
    url "https://pypi.python.org/packages/source/g/guessit/guessit-1.0.2.tar.gz"
    sha256 "118ca3e2df5adf1f0b87841924227fbb51b4465fb13407099c7c07588a20eccc"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.8.1.tar.gz"
    sha256 "e2127626a91e6c885db89668976db31020f0af2da728924b56480fc7ccf09649"
  end

  resource "pysrt" do
    url "https://pypi.python.org/packages/source/p/pysrt/pysrt-1.0.1.tar.gz"
    sha256 "5300a1584c8d15a1c49ef8880fa1ef7a4274ce3f24dde83ad581d12d875f6784"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://pypi.python.org/packages/source/s/stevedore/stevedore-1.10.0.tar.gz"
    sha256 "f5d689ef38e0ca532d57a03d1ab95e89b17c57f97b58d10c92da94699973779f"
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
    (testpath/".config").mkpath
    system "#{bin}/subliminal", "download", "-l", "en",
           "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert File.exist?("The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt")
  end
end
