class Libxmi < Formula
  desc "C/C++ function library for rasterizing 2D vector graphics"
  homepage "https://www.gnu.org/software/libxmi/"
  url "http://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz"
  mirror "https://ftp.gnu.org/libxmi/libxmi-1.2.tar.gz"
  sha256 "9d56af6d6c41468ca658eb6c4ba33ff7967a388b606dc503cd68d024e08ca40d"

  bottle do
    cellar :any
    revision 2
    sha256 "b8a406a6559eb59890d519e41c824f75f1b37027e6dda108f3648d85480ba5f8" => :yosemite
    sha256 "fe1bd51baf04d248d233d92ed8c2343d49b03e09427dd6774a86cabfc21372e9" => :mavericks
    sha256 "1bfaff32eb89a52d7a3b3ef98e2e7070df837d904590c0c54e31df3e61e01172" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end
end
