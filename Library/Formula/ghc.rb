require 'formula'

class Ghc < Formula
  homepage "http://haskell.org/ghc/"
  url "https://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-src.tar.xz"
  sha1 "fe86ae790b7e8e5b4c78db7a914ee375bc6d9fc3"

  option "32-bit"
  option "tests", "Verify the build using the testsuite."

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard

  # GHC 7.6 —which we might use for bootstrapping— still needs GCC
  depends_on "gcc" => :build if (build.build_32_bit? or
                                 not MacOS.prefer_64_bit? or
                                 MacOS::Xcode.version < "5.1")

  resource "7.8.2-x86_64-binary" do
    url "https://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-x86_64-apple-darwin-mavericks.tar.bz2"
    sha1 "efe602841300bcd887c46555fbc66fb67de34ebd"
  end

  resource "7.6.3-i386-binary" do
    url "https://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-i386-apple-darwin.tar.bz2"
    sha1 "6a312263fef41e06003f0676b879f2d2d5a1f30c"
  end

  resource "7.6.3-x86_64-binary" do
    url "https://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2"
    sha1 "fb9f18197852181a9472221e1944081985b75992"
  end

  resource "testsuite" do
    url "https://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-testsuite.tar.xz"
    sha1 "3abe4e0ebbed17e825573f0f34be0eca9179f9e4"
  end

  def install
    # Move the main tarball contents into a subdirectory
    (buildpath+"Ghcsource").install Dir["*"]

    if (build.build_32_bit? or not MacOS.prefer_64_bit?)
      binary_resource = "7.6.3-i386-binary"
      arch = "i386"
    elsif MacOS::Xcode.version < "5.1"
      binary_resource = "7.6.3-x86_64-binary"
      arch = "x86_64"
    else
      binary_resource = "7.8.2-x86_64-binary"
      arch = "x86_64"
    end

    resource(binary_resource).stage do
      # Define where the subformula will temporarily install itself
      subprefix = buildpath+"subfo"

      args = ["--prefix=#{subprefix}"]
      system "./configure", *args
      ENV.deparallelize
      system "make", "install"
      ENV.prepend_path "PATH", subprefix/"bin"
    end

    cd "Ghcsource" do
      # ENV.m32 if arch = "i386" # Need to force this to fix build error on internal libgmp_ar.
      # (commented out to see if the 32-bit builds still fail)

      args = ["--prefix=#{prefix}",
              "--build=#{arch}-apple-darwin"]

      system "./configure", *args
      system "make"

      if build.include? "tests"
        resource("testsuite").stage do
          cd "testsuite" do
            (buildpath+"Ghcsource/config").install Dir["config/*"]
            (buildpath+"Ghcsource/driver").install Dir["driver/*"]
            (buildpath+"Ghcsource/mk").install Dir["mk/*"]
            (buildpath+"Ghcsource/tests").install Dir["tests/*"]
            (buildpath+"Ghcsource/timeout").install Dir["timeout/*"]
          end
          cd (buildpath+"Ghcsource/tests") do
            system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
          end
        end
      end

      system "make"
      ENV.deparallelize
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end

  test do
    hello = (testpath/"hello.hs")
    hello.write('main = putStrLn "Hello Homebrew"')
    output = `echo "main" | '#{bin}/ghci' #{hello}`
    assert $?.success?
    assert_match /Hello Homebrew/i, output
  end
end
