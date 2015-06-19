require 'formula'

class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage 'http://dmalloc.com'
  url 'http://dmalloc.com/releases/dmalloc-5.5.2.tgz'
  sha1 '20719de78decbd724bc3ab9d6dce2ea5e5922335'

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
