class InputSourceSwitcher < Formula
  homepage "https://github.com/vovkasm/input-source-switcher"
  url "https://github.com/vovkasm/input-source-switcher/archive/v0.2.tar.gz"
  sha256 "1e6507274a3384e24088e1b31a93fa06436132906c251a1f28a23e521753376f"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/issw", "-l"
  end
end
