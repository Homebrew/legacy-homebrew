class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.11/kyua-0.11.tar.gz"
  sha256 "2b8b64a458b642df75086eeb73e8073d105b8d9cff04c9b1a905b68bc8502560"

  bottle do
    sha256 "c64ff3815d5a237ee32ca2c3fa46ed9508b055dc6ab33e814f484e7dd0e04578" => :el_capitan
    sha1 "d9aec0a429eea528157e8f9442a39601047b29c9" => :yosemite
    sha1 "34c93c5aca199d6b6382c067d1b9e7b4899a3e32" => :mavericks
    sha1 "a44bd2fbf521782a7f9e93b85ef48ebfd3d38b91" => :mountain_lion
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
