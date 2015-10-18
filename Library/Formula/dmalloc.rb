class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "http://dmalloc.com"
  url "http://dmalloc.com/releases/dmalloc-5.5.2.tgz"
  sha256 "d3be5c6eec24950cb3bd67dbfbcdf036f1278fae5fd78655ef8cdf9e911e428a"

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
