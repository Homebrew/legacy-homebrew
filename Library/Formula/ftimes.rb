require "formula"

class Ftimes < Formula
  desc "System baselining and evidence collection tool"
  homepage "http://ftimes.sourceforge.net/FTimes/index.shtml"
  url "https://downloads.sourceforge.net/project/ftimes/ftimes/3.11.0/ftimes-3.11.0.tgz"
  sha1 "83ec09be7978d1a834f57bdb64c54d4a98a88536"

  depends_on "pcre"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-pcre=#{Formula['pcre'].opt_prefix}",
                          "--prefix=#{prefix}"

    inreplace "doc/ftimes/Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", man1
    end

    system "make install"
  end
end
