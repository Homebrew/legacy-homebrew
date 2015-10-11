class Yafc < Formula
  desc "Command-line FTP client"
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/downloads/yafc-1.3.6.tar.xz"
  sha256 "63a32556ed16a589634a5aca3f03134b8d488e06ecb36f9df6ef450aa3a47973"

  bottle do
    revision 2
    sha256 "85e490aee51701da0f7602b9d88700f18b6b2077dcae1f17c5c479132dd78d2e" => :el_capitan
    sha256 "3f5fc5f56cce04404d49d82173d4aea09b3fdfd3dec7b3699ea106b947a6df2a" => :yosemite
    sha256 "5f178c01235c5dd28bd359eb295a4a0aa848649c63a0a0386f43516d32b66bd2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libssh" => :recommended

  # Upstream commit to fix the sed flags for OSX in the bash-completion script
  patch do
    url "https://github.com/sebastinas/yafc/commit/e8e31e4191f252ab1b58a486e85aabfa28c8da65.diff"
    sha256 "55b361e7ff87f85776a0cd4560b3c39a7f7db132a232c71265e567d734f11f25"
  end

  # Upstream commit to fix the parsing of mode when using chmod on ssh
  patch do
    url "https://github.com/sebastinas/yafc/commit/a16c1c985f3d4e2b676231f4773358927041d8e9.diff"
    sha256 "ca6c6f81e71dec4090bd29395599075d24374a818bc822910bb14e0f144a8cdd"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]
    args << "--without-ssh" if build.without? "libssh"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/yafc", "-V"
  end
end
