class Yafc < Formula
  desc "Command-line FTP client"
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/downloads/yafc-1.3.6.tar.xz"
  sha256 "63a32556ed16a589634a5aca3f03134b8d488e06ecb36f9df6ef450aa3a47973"

  bottle do
    revision 1
    sha256 "b87148e473ec1eb83a41b972a019b6b21666a79c28c98e5e73b8583fc4e0d407" => :yosemite
    sha256 "745665aeff483e13c92cfe7c7c1d33ec3b724ff91d772dd44a42216f15fc44af" => :mavericks
  end

  depends_on "readline"
  depends_on "libssh" => :recommended
  depends_on "pkg-config" => :build

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
    readline = Formula["readline"].opt_prefix

    args = ["--prefix=#{prefix}",
            "--with-readline=#{readline}"]
    args << "--without-ssh" if build.without? "libssh"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/yafc", "-V"
  end
end
