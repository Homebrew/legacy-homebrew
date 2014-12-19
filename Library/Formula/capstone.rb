require "formula"

class Capstone < Formula
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0/capstone-3.0.tgz"
  sha1 "26e591b8323ed3f6e92637d7ee953cb505687efa"
  revision 1

  bottle do
    cellar :any
    sha1 "ab195b7884a37afc24ea36a8d0e722bb95e19045" => :yosemite
    sha1 "36b3f1d91609bd23fc48fc3fe594ce775635e119" => :mavericks
    sha1 "22dc40e9afc3037a0312f22ae8324395459063dc" => :mountain_lion
  end

  def install
    # Capstone's Make script ignores the prefix env and was installing
    # in /usr/local directly. So just inreplace the prefix for less pain.
    # https://github.com/aquynh/capstone/issues/228
    inreplace "make.sh", "export PREFIX=/usr/local", "export PREFIX=#{prefix}"

    ENV["HOMEBREW_CAPSTONE"] = "1"
    system "./make.sh"
    system "./make.sh", "install"
  end

  test do
    # Given the build issues around prefix, check is actually in the Cellar.
    assert File.exist? "#{lib}/libcapstone.a"
  end
end
