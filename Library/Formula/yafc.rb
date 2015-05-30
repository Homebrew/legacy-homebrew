class Yafc < Formula
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/upload/yafc-1.3.6.tar.xz"
  sha256 "63a32556ed16a589634a5aca3f03134b8d488e06ecb36f9df6ef450aa3a47973"

  depends_on "readline"
  depends_on "libssh" => :recommended
  depends_on "pkg-config" => :build

  # Upstream commit to fix the sed flags for OSX in the bash-completion script
  patch do
    url "https://github.com/sebastinas/yafc/commit/e8e31e4191f252ab1b58a486e85aabfa28c8da65.diff"
    sha256 "55b361e7ff87f85776a0cd4560b3c39a7f7db132a232c71265e567d734f11f25"
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
