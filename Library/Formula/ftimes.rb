class Ftimes < Formula
  desc "System baselining and evidence collection tool"
  homepage "http://ftimes.sourceforge.net/FTimes/index.shtml"
  url "https://downloads.sourceforge.net/project/ftimes/ftimes/3.11.0/ftimes-3.11.0.tgz"
  sha256 "70178e80c4ea7a8ce65404dd85a4bf5958a78f6a60c48f1fd06f78741c200f64"
  revision 1

  depends_on "pcre"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-server-prefix=#{var}/ftimes"

    inreplace "doc/ftimes/Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", man1
    end

    system "make", "install"
  end

  test do
    assert_match /ftimes #{version}/, shell_output("#{bin}/ftimes --version")
  end
end
