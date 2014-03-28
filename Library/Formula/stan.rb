require "formula"

class Stan < Formula
  homepage "http://mc-stan.org"
  url "https://github.com/stan-dev/stan/archive/v2.2.0.tar.gz"
  sha1 "4c9be875f3627bb5e1089fd24600aa4fa4f862f3"

  depends_on :xcode
  
  keg_only "We don't want sym-links."
  
  def install
    system "make","bin/libstan.a"
    system "make", "-j2", "bin/stanc"
    system "make", "bin/print"
    #(var/"stan-home").install "makefile"
    #(var/"stan-home/bin").install Dir["bin/*"]
    #(var/"stan-home").install "bin" => "bin"
    mkdir_p "#{HOMEBREW_PREFIX}/var/stan-home/bin"
    cp "bin/libstan.a", "#{HOMEBREW_PREFIX}/var/stan-home/bin"
    #(var/"stan-home/make").install Dir["make/*"]
    #(var/"stan-home/src").install Dir["src/*"]
    #(var/"stan-home/lib").install Dir["lib/*"]
    #doc.install Dir["doc/*"]
    #lib.install Dir["lib/*"]
    #(prefix/"src").install Dir["src/*"]
    # prefix.install Dir["*"]
    #bin.install Dir["bin/*"]
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
