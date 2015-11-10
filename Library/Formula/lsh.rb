class Lsh < Formula
  desc "GNU implementation of the Secure Shell (SSH) protocols"
  homepage "https://www.lysator.liu.se/~nisse/lsh/"
  url "http://ftpmirror.gnu.org/lsh/lsh-2.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/lsh/lsh-2.1.tar.gz"
  sha256 "8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3"

  bottle do
    revision 1
    sha256 "5ade7c67942a35410f130ef1fb76548161e3be2dc22307d2ddc77d21fa24b2ef" => :el_capitan
    sha256 "ef1ee7f5b0cc58ef8820924f46f2a82f6c72c373317cbca4ff3567499a86e59b" => :yosemite
    sha256 "620b97949d1fb024fcf5019455e1cb4d28b9ad498aadcf2d1aac4fa67735fd40" => :mavericks
  end

  depends_on :x11 => :optional # For libXau library
  depends_on "nettle"
  depends_on "gmp"

  resource "liboop" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
    sha256 "34d83c6e0f09ee15cb2bc3131e219747c3b612bb57cf7d25318ab90da9a2d97c"
  end

  def install
    resource("liboop").stage do
      system "./configure", "--prefix=#{libexec}/liboop", "--disable-dependency-tracking",
                            "--without-tcl", "--without-readline", "--without-glib"
      system "make", "install"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    # Find the sandboxed liboop.
    ENV.append "LDFLAGS", "-L#{libexec}/liboop/lib"
    # Compile fails without passing gnu89.
    ENV.append_to_cflags "-I#{libexec}/liboop/include -std=gnu89"

    system "./configure", *args
    system "make", "install"
    # To avoid bumping into Homebrew/Dupes' OpenSSH:
    rm "#{man8}/sftp-server.8"
  end

  test do
    system "#{bin}/lsh", "--list-algorithms"
  end
end
