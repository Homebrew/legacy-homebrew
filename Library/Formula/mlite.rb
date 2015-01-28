class Mlite < Formula
  homepage "http://t3x.org/mlite/index.html"

  devel do
    url "http://t3x.org/mlite/mlite-20141229.tgz"
    sha1 "2c150bbbff33fa6bbd9aac7de00a374c129105f5"
  end

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.m").write("len ` iota 1000")
    system "#{bin}/mlite", "-f", "test.m"
  end
end
