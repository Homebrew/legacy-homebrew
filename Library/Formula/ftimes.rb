class Ftimes < Formula
  desc "System baselining and evidence collection tool"
  homepage "http://ftimes.sourceforge.net/FTimes/index.shtml"
  url "https://downloads.sourceforge.net/project/ftimes/ftimes/3.11.0/ftimes-3.11.0.tgz"
  sha256 "70178e80c4ea7a8ce65404dd85a4bf5958a78f6a60c48f1fd06f78741c200f64"

  depends_on "pcre"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--prefix=#{prefix}"

    inreplace "doc/ftimes/Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", man1
    end

    system "make", "install"
  end
end
