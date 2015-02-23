class Capstone < Formula
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0.1/capstone-3.0.1.tgz"
  sha1 "7f206c853c6b8d05de22e919c2455ab661654093"

  bottle do
    cellar :any
    revision 2
    sha1 "12179821d14b839d25cb0371fdb33da5bd9c6e71" => :yosemite
    sha1 "0f6fcb777a351817bbec8084643da1184669f9e8" => :mavericks
    sha1 "635d65b51b01e1dc5977d154fd5fcfaa6e0c77d8" => :mountain_lion
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
      s.gsub! "/usr/include/capstone", "#{include}/capstone"
    end
  end

  test do
    # Given the build issues around prefix, check is actually in the Cellar.
    assert File.exist? "#{lib}/libcapstone.a"
  end
end
