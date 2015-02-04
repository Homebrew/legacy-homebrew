class Bear < Formula
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.0.1.tar.gz"
  sha1 "31cf2b82a44f6eb5a3740c9f8aa9f2cd662e9a68"
  head "https://github.com/rizsotto/Bear.git"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libconfig"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bear", "true"
    assert File.exist? "compile_commands.json"
  end
end
