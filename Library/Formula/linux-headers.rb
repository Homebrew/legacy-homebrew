class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "http://kernel.org/"
  url "https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.9.tar.gz"
  sha256 "648143d560db550e417ce0532017c310cc966d5428a74042cdb69ce64e9b5c8c"
  # tag "linuxbrew"

  bottle do
    cellar :any
    sha256 "f8aa29cafbdfd0a815970dfcffe5e56cc9a8033b34caee5ea5483e729cff9700" => :x86_64_linux
  end

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end
end
