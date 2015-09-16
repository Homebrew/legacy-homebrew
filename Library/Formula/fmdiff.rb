class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://www.defraine.net/~brunod/fmdiff/"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  head "https://github.com/brunodefraine/fmscripts.git"

  bottle do
    sha256 "a713fc8fb048aaaac4dcac2a79933a54ff229d5ede4024a10399255f2114c502" => :yosemite
    sha256 "bbce86236cc094efb560d2f4492bb35e49ff45aefc99d063192232ea4f6a6fcb" => :mavericks
    sha256 "6ed6345bf6d69a8d33f6f6f72c836088ed10deaf397f8d2742059f810c14aaa2" => :mountain_lion
  end


  def install
    system "make"
    system "make", "DESTDIR=#{bin}", "install"
  end

  test do
    ENV.prepend_path "PATH", testpath

    # dummy filemerge script
    (testpath/"filemerge").write <<-EOS.undent
      #!/bin/sh
      echo "it works"
    EOS

    chmod 0744, testpath/"filemerge"
    touch "test"

    assert_match(/it works/, shell_output("#{bin}/fmdiff test test"))
  end
end
