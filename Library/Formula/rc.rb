class Rc < Formula
  desc "Implementation of the AT&T Plan 9 shell"
  homepage "http://doc.cat-v.org/plan_9/4th_edition/papers/rc"
  url "ftp://rc.quanstro.net/pub/rc-1.7.2.tgz"
  sha256 "89487c6c9f5ad0fdae658bf9564f6e920935bbdeabf63abdbf69b7c46f7ee40c"

  bottle do
    cellar :any
    sha256 "1628bbad2fa8417318ee488a748a1ae769606baf950300c895e4592cbe013edf" => :yosemite
    sha256 "6cd2807091b6e1e8359ebedab8d211f00d0ac84825f16d116bd4500c6dd5b3f4" => :mavericks
    sha256 "c09ab4ed5d45ef028bb235e246e32b7e5d0603952a7c9e068ba64faf78e16cf1" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-editline"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rc", "-c", "echo Hello!"
  end
end
