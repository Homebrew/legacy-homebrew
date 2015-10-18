class Lsh < Formula
  desc "GNU implementation of the Secure Shell (SSH) protocols"
  homepage "https://www.lysator.liu.se/~nisse/lsh/"
  url "http://ftpmirror.gnu.org/lsh/lsh-2.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/lsh/lsh-2.1.tar.gz"
  sha256 "8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3"

  bottle do
    sha1 "72d573729a1ab019f2b1f5f7f53a2dd6b9096044" => :yosemite
    sha1 "059c5b4112b9f1d1645bcd98a42c0e8524ecaf8d" => :mavericks
    sha1 "72229b6a88ad27b22f4904d3a4b3a3539bb9b09b" => :mountain_lion
  end

  depends_on :x11 => :optional # For libXau library
  depends_on "nettle"
  depends_on "gmp"

  resource "liboop" do
    url "https://mirrors.kernel.org/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
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
    # Compile lsh without the 89 flag? Ha, Nope!
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
