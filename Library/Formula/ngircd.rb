class Ngircd < Formula
  desc "Next generation IRC daemon"
  homepage "http://ngircd.barton.de"
  url "http://ngircd.barton.de/pub/ngircd/ngircd-23.tar.gz"
  mirror "http://ngircd.mirror.3rz.org/pub/ngircd/ngircd-23.tar.gz"
  sha256 "99b8b67a975a9ae9b81c96bdee02133a10f515c718825d34cedcb64f1fc95e73"

  bottle do
    sha256 "30b362de911c6812d085e27c61c5aa66a1f4f3e598f6306613c91f6a74081f29" => :yosemite
    sha256 "4ac8d533f8aa16a28a55d45f752ae9a8ac6e541b0cbf8e043752d2b33f964631" => :mavericks
    sha256 "ec8f4c6e61e924fe46e90df8a7d7041037c752b4e03cb11c5643bb03ae771909" => :mountain_lion
  end

  option "with-iconv", "Enable character conversion using libiconv."
  option "with-pam", "Enable user authentication using PAM."
  option "with-sniffer", "Enable IRC traffic sniffer (also enables additional debug output)."
  option "with-debug", "Enable additional debug output."

  # Older Formula used the next option by default, so keep it unless
  # deactivated by the user:
  option "without-ident", "Disable 'IDENT' ('AUTH') protocol support."

  depends_on "libident" if build.with? "ident"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{HOMEBREW_PREFIX}/etc
      --enable-ipv6
      --with-openssl
    ]

    args << "--with-iconv" if build.with? "iconv"
    args << "--with-ident" if build.with? "ident"
    args << "--with-pam" if build.with? "pam"
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-sniffer" if build.with? "sniffer"

    system "./configure", *args
    system "make", "install"

    prefix.install "contrib/MacOSX/de.barton.ngircd.plist.tmpl" => "de.barton.ngircd.plist"
    (prefix+"de.barton.ngircd.plist").chmod 0644

    inreplace prefix+"de.barton.ngircd.plist" do |s|
      s.gsub! ":SBINDIR:", sbin
      s.gsub! "/Library/Logs/ngIRCd.log", var/"Logs/ngIRCd.log"
    end
  end

  test do
    # Exits non-zero, so test version and match Author's name supplied.
    assert_match /Alexander/, pipe_output("#{sbin}/ngircd -V 2>&1")
  end
end
