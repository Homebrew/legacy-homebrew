class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "14bb0680842b8b392cb1a5f5baf142e99a54a538d1a587f6d1158785b276ffc6" => :el_capitan
    sha256 "da6c24f1cc40fdf6ae286ec003ecd779d0f866fe850e36f5e5953786fa45a561" => :yosemite
    sha256 "5deeef3625d52f71d633e7510396d0028ec7b7ccf40c78b5d254bdf4214e6363" => :mavericks
    sha256 "739e17a9f4e75913118a8ef0fd2a7ad7d645769cc61aeb1d6bcf760fe4bd48a7" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
