class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "http://nekovm.org"
  # revision includes recent parameterized build targets for mac.  Use a :tag
  # on the next release
  url "https://github.com/HaxeFoundation/neko.git", :revision => "22c49a89b56b9f106d7162710102e9475227e882"
  version "2.0.0-22c49a8"
  revision 2

  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    sha256 "08e27a02801d60a36971ef04892c8737402d94611c8cce5e6abdfc0066f2d8ce" => :yosemite
    sha256 "fd20435ab471a197439ef8b15bc22e20ed63e5bee586b0a64d811a8a178a4c3b" => :mavericks
    sha256 "a45ce3f4eab713bea15f8b34045333462d3e6a971c10257b9789ffc8000951e2" => :mountain_lion
  end

  depends_on "bdw-gc"
  depends_on "pcre"
  depends_on "openssl"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make", "os=osx", "LIB_PREFIX=#{HOMEBREW_PREFIX}", "INSTALL_FLAGS="

    include.install Dir["vm/neko*.h"]
    neko = lib/"neko"
    neko.install Dir["bin/*"]

    # Symlink into bin so libneko.dylib resolves correctly for custom prefix
    %w[neko nekoc nekoml nekotools].each do |file|
      bin.install_symlink neko/file
    end
    lib.install_symlink neko/"libneko.dylib"
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "#{HOMEBREW_PREFIX}/lib/neko/test.n"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<-EOS.undent
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
        EOS
    end
    s
  end
end
