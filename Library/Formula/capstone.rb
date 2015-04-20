class Capstone < Formula
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0.2/capstone-3.0.2.tgz"
  sha1 "7e2cb9a94f4cda478bc011bcf409d55fcdab6aec"

  bottle do
    cellar :any
    sha256 "8fb84e2b01d5fbc24bb055c24ddcfd860193e439ee82704d321cc5ed9bb0332a" => :yosemite
    sha256 "0c04d84516082b92728baae61971b85a3e5221010d6e2189a719327a3ee88c25" => :mavericks
    sha256 "40241a0b359a0ee16a9593ec159f2499c4f15afdb0cd3799cced55014e8ec0c6" => :mountain_lion
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
