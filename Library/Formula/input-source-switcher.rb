class InputSourceSwitcher < Formula
  homepage "https://github.com/vovkasm/input-source-switcher"
  url "https://github.com/vovkasm/input-source-switcher/archive/cfca8149c6805b333910858a22aeeb124cbca903.zip"
  version "source"
  sha256 "9bc786aa2395c56e4d4f25e1b2c20c89e3b9b51ce4b56417df5dbd215569801c"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # This will set change the current keyboard layout to a standard US layout.
    # Ideally this should lookup the current layout first? And set it back to
    # that.
    system "${bin}/issw" "en"
  end
end
