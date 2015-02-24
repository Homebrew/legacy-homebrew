class Capstone < Formula
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0.1/capstone-3.0.1.tgz"
  sha1 "7f206c853c6b8d05de22e919c2455ab661654093"

  bottle do
    cellar :any
    revision 3
    sha1 "63e887ea699a71bbd3f08d5dfa8cbbb8f061f768" => :yosemite
    sha1 "210d46b2de72092f42df324e29297397405acbb0" => :mavericks
    sha1 "eb835f4d9bdcd7d465224f7bd6ab47b21287da94" => :mountain_lion
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
