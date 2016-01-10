class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.11/kyua-0.11.tar.gz"
  sha256 "2b8b64a458b642df75086eeb73e8073d105b8d9cff04c9b1a905b68bc8502560"

  bottle do
    sha256 "c64ff3815d5a237ee32ca2c3fa46ed9508b055dc6ab33e814f484e7dd0e04578" => :el_capitan
    sha256 "3d2bbb23c7b1b7599cc55e5f6de9474f3e6fedfb73e993da0345e8502bc7c3e6" => :yosemite
    sha256 "854b21751c3e76ad484b693d19c58745b7e666de234f067b9f40814e984a9332" => :mavericks
    sha256 "76c4f08417963cda929dbbf017c4617c89b336b78a74004f4b8baa95e150738d" => :mountain_lion
  end

  depends_on "atf"
  depends_on "lutok"
  depends_on "pkg-config" => :build
  depends_on "lua"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "install"
  end
end
