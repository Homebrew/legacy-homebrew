class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://www.defraine.net/~brunod/fmdiff/"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  head "https://github.com/brunodefraine/fmscripts.git"

  bottle do
    sha256 "345e00779b91f98c2e675344572b8b93345f049ece5f8df136a7fd561d7dd1e9" => :el_capitan
    sha256 "157f975ba1f93d323bf215bb0e18e3d474071d1a5060211fea4176c4a872ccb7" => :yosemite
    sha256 "af27122257b358518d38a86d8bdc1242b17e7f1fe6e5e08dc7b7a8a3b1151148" => :mavericks
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
