class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/fiki/bin/view/HTP"
  url "http://www.vervest.org/htp/archive/c/htpdate-0.9.1.tar.bz2"
  sha256 "2afd132b00d33cd45eea9445387441174fe9bedf3fdf72c5a19f0051cf5a2446"

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-h"
  end
end
