class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://www.defraine.net/~brunod/fmdiff/"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  head "https://github.com/brunodefraine/fmscripts.git"

  bottle do
    revision 1
    sha256 "ba9108d500e3cf771c1f1b0430d7fe92c3e5743265dc001c1dbd70d260fbbd7a" => :el_capitan
    sha256 "11aa1ef52e2f54cc99f5ad2587d204bc83e9f08aa5eb2823f2831376e8b53846" => :yosemite
    sha256 "9905051e6b7fea4e23e0c9a1adedae94e6a52c0f471a955a532320849fd8ae18" => :mavericks
  end

  # Needs FileMerge.app, which has been part of Xcode since Xcode 4 (OS X 10.7)
  # Prior to that it was included in the Developer Tools package.
  # "make" has logic for checking both possibilities.
  depends_on :xcode if MacOS.version >= :lion

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
