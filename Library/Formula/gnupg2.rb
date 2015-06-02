class Gnupg2 < Formula
  homepage "https://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.28.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.28.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.28.tar.bz2"
  sha256 "ce092ee4ab58fd19b9fb34a460c07b06c348f4360dd5dd4886d041eb521a534c"

  bottle do
    sha1 "68caf3377045b2ca989fbfb0dbea822f1c05886a" => :yosemite
    sha1 "a43d2c5d929e6dd706774fdbfd1eeb282c4ca524" => :mavericks
    sha1 "4e1697673d235ec19cf28d89f3ef015920c6e292" => :mountain_lion
  end

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pinentry"
  depends_on "pth"
  depends_on "gpg-agent"
  depends_on "curl" if MacOS.version <= :mavericks
  depends_on "dirmngr" => :recommended
  depends_on "libusb-compat" => :recommended
  depends_on "readline" => :optional

  def install
    # Adjust package name to fit our scheme of packaging both gnupg 1.x and
    # 2.x, and gpg-agent separately, and adjust tests to fit this scheme
    inreplace "configure" do |s|
      s.gsub! "PACKAGE_NAME='gnupg'", "PACKAGE_NAME='gnupg2'"
      s.gsub! "PACKAGE_TARNAME='gnupg'", "PACKAGE_TARNAME='gnupg2'"
    end
    inreplace "tests/openpgp/Makefile.in" do |s|
      s.gsub! "required_pgms = ../../g10/gpg2 ../../agent/gpg-agent",
              "required_pgms = ../../g10/gpg2"
      s.gsub! "../../agent/gpg-agent --quiet --daemon sh",
              "gpg-agent --quiet --daemon sh"
    end
    inreplace "tools/gpgkey2ssh.c", "gpg --list-keys", "gpg2 --list-keys"

    (var/"run").mkpath

    ENV.append "LDFLAGS", "-lresolv"

    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    agent = Formula["gpg-agent"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --enable-symcryptrun
      --disable-agent
      --with-agent-pgm=#{agent}/bin/gpg-agent
      --with-protect-tool-pgm=#{agent}/libexec/gpg-protect-tool
    ]

    if build.with? "readline"
      args << "--with-readline=#{Formula["readline"].opt_prefix}"
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Conflicts with a manpage from the 1.x formula, and
    # gpg-zip isn't installed by this formula anyway
    rm_f man1/"gpg-zip.1"
  end

  test do
    system "#{bin}/gpgconf"
  end
end
