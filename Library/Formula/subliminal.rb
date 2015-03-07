require "formula"

class Subliminal < Formula
  homepage "https://subliminal.readthedocs.org"
  url "https://github.com/Diaoul/subliminal/archive/0.7.4.tar.gz"
  sha1 "1aa91ed944bbf14793f0c7f689a336df75f467f7"

  bottle do
    cellar :any
    revision 1
    sha1 "8625822a2fa45a74437c0f885475d4858e660091" => :yosemite
    sha1 "608010d410137ad0ba71bdc4e115ee5f3283e8fe" => :mavericks
    sha1 "633ca93147b2d58b50413d354e0d2dff5999abb8" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "charade" do
    url "https://pypi.python.org/packages/source/c/charade/charade-1.0.3.tar.gz"
    sha1 "6bf65ae4b60d13e89bd7afe1704eef5bd0b787bc"
  end

  # Don't upgrade >0.7.0 - Package incompatible with above.
  resource "guessit" do
    url "https://pypi.python.org/packages/source/g/guessit/guessit-0.6.2.tar.gz"
    sha1 "74e09f1821ef0df85b55355e22c9651db397e2f5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  resource "pysrt" do
    url "https://pypi.python.org/packages/source/p/pysrt/pysrt-1.0.1.tar.gz"
    sha1 "b31e5e407a34dfd5ca3b7a340b3379c47bfdd1ee"
  end

  resource "html5lib" do
    url "https://pypi.python.org/packages/source/h/html5lib/html5lib-0.999.tar.gz"
    sha1 "bc30bb7132c06d9241a672f40b3ade32d7eab12d"
  end

  resource "enzyme" do
    url "https://pypi.python.org/packages/source/e/enzyme/enzyme-0.4.1.tar.gz"
    sha1 "7f798c481d292fe3a9f7d0a07a8cd661e9c6d8af"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha1 "50af8f8771ecbeb7a22567129c6c281b8bec3b1c"
  end

  resource "dogpile.core" do
    url "https://pypi.python.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha1 "68365e1ee870a55cb4a09a30ea4cafb0d264aecb"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.4.3.tar.gz"
    sha1 "411f1bfa44556f7dd0f34cd822047c31baa7d741"
  end

  # Don't upgrade >0.5.0 - Package incompatible with above.
  resource "babelfish" do
    url "https://pypi.python.org/packages/source/b/babelfish/babelfish-0.4.0.tar.gz"
    sha1 "646bbeb8b8df1936c34ad693f7bba6c192a77ded"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz"
    sha1 "8ff340de807ae5038bd4e6cc1b1e5b6c16d49ed0"
  end

  resource "dogpile.cache" do
    url "https://pypi.python.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.4.tar.gz"
    sha1 "bc1dff9b2f1bbe2a09ca5e16d0d160a730ef8732"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.2.tar.gz"
    sha1 "fbafcd19ea0082b3ecb17695b4cb46070181699f"
  end

  resource "colorlog" do
    url "https://pypi.python.org/packages/source/c/colorlog/colorlog-2.4.0.tar.gz"
    sha1 "30b4a621ec372ba4ab367cb5446a4a4293f6e9ed"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    %w[six charade guessit pysrt html5lib enzyme chardet dogpile.core requests babelfish beautifulsoup4 dogpile.cache python-dateutil colorlog].each do |r|
      resource(r).stage do
        system "python", "setup.py", "install", "--prefix=#{libexec}", "--record=installed.txt"
      end
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
           "--single-version-externally-managed", "--record=installed.txt"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/subliminal", "-l", "en", "--", "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
  end
end
