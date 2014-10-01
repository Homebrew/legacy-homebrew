require "formula"

class Ghc612 < Formula
  homepage "http://www.haskell.org/ghc/"
  if OS.linux?
    url "http://www.haskell.org/ghc/dist/6.12.3/ghc-6.12.3-x86_64-unknown-linux-n.tar.bz2"
    sha1 "a06a9041757b089f5a37c2c05feab767b54ec1f5"
  else
    raise "ghc612 is not available for your platform"
  end

  conflicts_with "ghc", :because => "both install bin/ghc"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ghc --version"
    hello = (testpath/"hello.hs")
    hello.write('main = putStrLn "Hello Homebrew"')
    output = `echo "main" | '#{bin}/ghci' #{hello}`
    assert $?.success?
    assert_match /Hello Homebrew/i, output
  end
end
