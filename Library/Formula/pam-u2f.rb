class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.0.4.tar.gz"
  sha256 "71542e4568e6d2acaa50810a93c67297ba402f960da1ebb621413bd31f0732a1"
  head "https://github.com/Yubico/pam-u2f.git"

  bottle do
    cellar :any
    sha256 "9718cd1b3cb8bd22b7f492191ed4a338119dd157cea531924fec10a53e1f017b" => :el_capitan
    sha256 "8df3bff3b7804b58b200d96c1e2b013cb68aa6f52de033c6f0bd01321523c9bc" => :yosemite
    sha256 "d1c6cdbb0ffba2af29c97623c83b2f5dc77f8da6d9d1cdd6ba9965f570a3810e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "asciidoc" => :build
  depends_on "libu2f-host"
  depends_on "libu2f-server"

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To use a U2F key for PAM authentication, specify the full path to the
    module (#{lib}/pam/pam_u2f.so) in a PAM
    configuration. You can find all PAM configurations in /etc/pam.d.

    For further installation instructions, please visit
    https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system "#{bin}/pamu2fcfg", "--version"
  end
end
