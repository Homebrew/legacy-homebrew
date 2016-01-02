class Libmetalink < Formula
  desc "C library to parse Metalink XML files"
  homepage "https://launchpad.net/libmetalink/"
  url "https://launchpad.net/libmetalink/trunk/libmetalink-0.1.3/+download/libmetalink-0.1.3.tar.xz"
  sha256 "86312620c5b64c694b91f9cc355eabbd358fa92195b3e99517504076bf9fe33a"

  bottle do
    cellar :any
    sha256 "4ca3f82ac2e2520c677def661168c6ba14ee2b8f0139fbe33cf5be66745244d3" => :el_capitan
    sha256 "e627cde406e135a735fd2586622d2fa05cf6ef9fda8a0ea08d09ddfce20dca75" => :yosemite
    sha256 "9ff31fac7dcd9f9231c067eff04d9b59e1de9f8416142d519799746dbfa34c24" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
