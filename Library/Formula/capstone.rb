class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "http://capstone-engine.org"
  url "http://capstone-engine.org/download/3.0.3/capstone-3.0.3.tgz"
  sha1 "0bb889ac8ba864b98892a17986075dea48be64b2"

  bottle do
    cellar :any
    sha256 "4b6a547cde768d88cb7a13549a5e1156282e9d524e691a7840b9689323eb860d" => :yosemite
    sha256 "7b271a58f25cc409df8c0cf87101250c50ee072f50d41b5fe0f884369327b608" => :mavericks
    sha256 "aaff57ed10734d1ef15f6e3f2c73be5d1841bad5ea98db9396fd3abe1d267c97" => :mountain_lion
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
