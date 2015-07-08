class Yafc < Formula
  desc "Command-line FTP client"
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/upload/yafc-1.3.6.tar.xz"
  sha256 "63a32556ed16a589634a5aca3f03134b8d488e06ecb36f9df6ef450aa3a47973"

  bottle do
    sha256 "98f7b7f7771dfe2d9c8e992ce9b31ee5d5734d056642a9dc8e1373f2a62ce0e0" => :yosemite
    sha256 "f50af31afd208189012ab71a498c2057276a12586e4b460aabd976e0ddcef8de" => :mavericks
    sha256 "0342f6efbb4decd0031b0c9e06dbb82951465cbb64a0b96fbec3ea24652b94f1" => :mountain_lion
  end

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
