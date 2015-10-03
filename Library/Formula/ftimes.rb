class Ftimes < Formula
  desc "System baselining and evidence collection tool"
  homepage "http://ftimes.sourceforge.net/FTimes/index.shtml"
  url "https://downloads.sourceforge.net/project/ftimes/ftimes/3.11.0/ftimes-3.11.0.tgz"
  sha256 "70178e80c4ea7a8ce65404dd85a4bf5958a78f6a60c48f1fd06f78741c200f64"
  revision 1

  bottle do
    sha256 "0cc52b1c4396b5adca1a3adc4a2942f0beef27392f23cb6533db79c54a3657ca" => :yosemite
    sha256 "214b8092f738542005f77d146cc6b85ee69f2f100469dc6e2b78b5f2f0b5c132" => :mavericks
    sha256 "fbe09e2f091d3b828a2f3802674203f4f72b6e0136fe6f442bf8313234be5373" => :mountain_lion
  end

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
