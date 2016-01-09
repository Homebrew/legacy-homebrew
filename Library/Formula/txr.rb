class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "http://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-131.tar.bz2"
  sha256 "55486f31c9bf9c97e9f77ad940417b87b37097595f31089438f88a650492c46c"
  head "http://www.kylheku.com/git/txr", :using => :git

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
