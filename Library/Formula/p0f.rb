class P0f < Formula
  desc "Versatile passive OS fingerprinting, masquerade detection tool"
  homepage "http://lcamtuf.coredump.cx/p0f3/"
  url "http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.08b.tgz"
  sha256 "da89a7fe4ba5db3704207f4bde231643bedd4fe8653ab8111c65766c8c768aec"

  bottle do
    cellar :any
    sha256 "7405d2d0d6070223be3cc0f2ed11c8cd52d886b1480931c1a7e9436d297dbbe7" => :yosemite
    sha256 "113e04c8f1fba685b42620838cb7fa6907431ff8b4f88ed5ab620f67a7a3aca1" => :mavericks
    sha256 "cced7b6bab2cdd563d47c6734efb170eb23e3295f25eedaf3294d78ad8812999" => :mountain_lion
  end

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc+"p0f").install "p0f.fp"
  end

  test do
    system "#{sbin}/p0f", "-r", test_fixtures("test.pcap")
  end
end
