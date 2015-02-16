class Capstone < Formula
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0.1/capstone-3.0.1.tgz"
  sha1 "7f206c853c6b8d05de22e919c2455ab661654093"

  bottle do
    cellar :any
    revision 1
    sha1 "78c4d8f9d3a9719edd74142985ccdbe8ac69876c" => :yosemite
    sha1 "0084bc1ee7bc57097950eef229e052df6886f069" => :mavericks
    sha1 "ed8318f71c886983d870ab47fc994ca95ad38dea" => :mountain_lion
  end

  def install
    # Capstone's Make script ignores the prefix env and was installing
    # in /usr/local directly. So just inreplace the prefix for less pain.
    # https://github.com/aquynh/capstone/issues/228
    inreplace "make.sh", "export PREFIX=/usr/local", "export PREFIX=#{prefix}"

    ENV["HOMEBREW_CAPSTONE"] = "1"
    system "./make.sh"
    system "./make.sh", "install"

    # As per the above inreplace, the pkgconfig file needs fixing as well.
    inreplace lib/"pkgconfig/capstone.pc" do |s|
      s.gsub! "/usr/lib", lib
      s.gsub! "/usr/include/capstone", include
    end
  end

  test do
    # Given the build issues around prefix, check is actually in the Cellar.
    assert File.exist? "#{lib}/libcapstone.a"
  end
end
