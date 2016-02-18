class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "http://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-133.tar.bz2"
  sha256 "3e2e598f71a60835f1ecbf3b80fbf8f9e9ef235c5ca204f1492bbf64a227cb90"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "d0ff86a1141a4906b79d1deb09f29d67f62e592ec93ac8878d394d18bbd8c731" => :el_capitan
    sha256 "9872c20d71cb9112b7aea4d68db9ae996408ca27048a687286c39ad6c68b0781" => :yosemite
    sha256 "da1a691c1939f768b066d2bd8d71a06f1ecb6d968e6eeb2231e01d16af646e66" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
