class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "http://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-133.tar.bz2"
  sha256 "3e2e598f71a60835f1ecbf3b80fbf8f9e9ef235c5ca204f1492bbf64a227cb90"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "5d42fb53ba6352ccb35c3da31d018c1c5561a76533dab578c315a9ef3eaa5210" => :el_capitan
    sha256 "cb89d9ee8c72b6f64ecf5acfd8dcea8016bc54d2a805b98b92ba8545fbdd92df" => :yosemite
    sha256 "b2d12be5344c90069c74db503704514121f9933766786fb389d3333db66189d8" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
