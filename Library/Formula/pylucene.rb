require "formula"

class Pylucene < Formula
  homepage "http://lucene.apache.org/pylucene/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=lucene/pylucene/pylucene-4.10.1-1-src.tar.gz"
  sha1 "650709590f4443ed711f100cc6e4f6850245899b"

  option "with-shared", "build jcc as a shared library"

  depends_on :ant => :build
  depends_on :java => "1.7"
  depends_on :python

  def install
    ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
    jcc = "JCC=python -m jcc --arch #{MacOS.preferred_arch}"
    opt = "INSTALL_OPT=--prefix #{prefix}"
    if build.with? "shared"
      jcc << " --shared"
      opoo "shared option requires python to be built with the same compiler: #{ENV.compiler}"
    else
      opt << " --use-distutils"  # setuptools only required with shared
      ENV["NO_SHARED"] = "1"
    end

    cd "jcc" do
      system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=install.txt"
    end
    ENV.deparallelize  # the jars must be built serially
    system "make", "all", "install", opt, jcc, "ANT=ant", "PYTHON=python", "NUM_FILES=8"
  end

  test do
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python2.7/site-packages"
    system "python", "-c", "import lucene; assert lucene.initVM()"
  end
end
