require "formula"

class Capstone < Formula
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0.1/capstone-3.0.1.tgz"
  sha1 "7f206c853c6b8d05de22e919c2455ab661654093"

  bottle do
    cellar :any
    sha1 "319b41766dd67e3017b83b1ce3df3cc81e6feb6a" => :yosemite
    sha1 "4f1bbe6b886c174924b1996aac7ed8d9850ff773" => :mavericks
    sha1 "5a73b99066037a6270f550e07bee8cbcb8e30a2c" => :mountain_lion
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
