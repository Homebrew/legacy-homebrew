class Lolcode < Formula
  homepage "http://lolcode.org"
  head "https://github.com/justinmeza/lolcode.git"
  # note: 0.10.* releases are stable versions, 0.11.* are dev ones
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha1 "6c5b996bb4defb77542a8fb525df9991b21139f9"

  depends_on "cmake" => :build

  conflicts_with "lci", :because => "both install `lci` binaries"

  def install
    system "cmake", "."
    system "make"
    # Don't use `make install` for this one file
    bin.install "lci"
  end

  test do
    path = testpath/"test.lol"
    path.write <<-EOS.undent
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS

    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end
