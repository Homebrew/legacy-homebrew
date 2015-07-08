class Rpl < Formula
  desc "Text replacement utility"
  homepage "http://www.laffeycomputer.com/rpl.html"
  url "http://downloads.laffeycomputer.com/current_builds/rpl-1.4.1.tar.gz"
  sha256 "291055dc8763c855bab76142b5f7e9625392bcefa524b796bc4ddbcf941a1310"

  bottle do
    cellar :any
    sha256 "d718355e56dd13c690f1d5a0541b5f051518f65b953aade9c525853a19266a61" => :yosemite
    sha256 "b0c4dbf06500053703ee4a8c8e751d43c435f0e3b0e25d2d328d310dcf490c23" => :mavericks
    sha256 "c59b98ff51670e96114daa8aa2c8984e35bd2bc1c2c01db9206bef9728a13624" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
