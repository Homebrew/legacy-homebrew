require "formula"

class Stan < Formula
  homepage "http://mc-stan.org"
  url "https://github.com/stan-dev/stan/archive/v2.2.0.tar.gz"
  sha1 "4c9be875f3627bb5e1089fd24600aa4fa4f862f3"

  depends_on :xcode

  def install
    system "make bin/libstan.a"
    system "make -j2 bin/stanc"
    system "make bin/print"
    #prefix.install "makefile"
    prefix.install Dir["*"]
    #prefix.install Dir["bin/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test stan`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "stan"
  end
end
