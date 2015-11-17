class Gnupg2 < Formula
  desc "GNU Privacy Guard: a free PGP replacement"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.29.tar.bz2"
  mirror "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.29.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.29.tar.bz2"
  sha256 "68ed6b386ba78425b05a60e8ee22785ff0fef190bdc6f1c612f19a58819d4ac9"

  bottle do
    sha256 "76d5ab157d1ee5dc047b972ae8082fcc21981d2bc2e0ba2c888a65f9bd384da3" => :el_capitan
    sha256 "506b7545cfd1ed03df482c3e8d8e3ad496401e92a8cdadd4c46a29954c2708ab" => :yosemite
    sha256 "d3163fd4191af0de8431bfa0a2ff0789d86a1e55b3e5b8c6742704a3acd8bb44" => :mavericks
    sha256 "fe5fb8a7c9f335dd674a238b0f988efae71aa1cd2fc9e1e2b12a644f3366d954" => :mountain_lion
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
