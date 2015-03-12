class Fmdiff < Formula
  homepage "https://www.defraine.net/~brunod/fmdiff/"
  url "http://bruno.defraine.net/fmdiff/fmscripts-20120813.tar.gz"
  sha256 "7312654040acc29787c15fb2b6d53abe0a397fb9faec6bf43398d25bb31f38ee"

  head "http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/", :using => :svn

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
