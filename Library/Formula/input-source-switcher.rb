class InputSourceSwitcher < Formula
  homepage "https://github.com/vovkasm/input-source-switcher"
  url "https://github.com/vovkasm/input-source-switcher/archive/v0.2.zip"
  version "0.2"
  sha256 "c98440f1d7d11762529377c47b979fc649859137403ec4cf5da0e70710544fec"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/issw -l"
  end
end
