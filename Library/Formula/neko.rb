require "formula"

class Neko < Formula
  homepage "http://nekovm.org"
  head "https://github.com/HaxeFoundation/neko.git"
  revision 1

  stable do
    # revision includes recent parameterized build targets for mac.  Use a :tag
    # on the next release
    url "https://github.com/HaxeFoundation/neko.git", :revision => "6ab8f48a8dc62e4d917b599b3d8c8e10f764f839"
    version "2.0.0-6ab8f48"

    # Revisit with each stable release. Could be a while though.
    depends_on MaximumMacOSRequirement => :mavericks
  end

  bottle do
    sha1 "3ef70ebed2f81e523da90926ec1900e23a7cfa40" => :mavericks
    sha1 "5b42966d7ff146962b8722b41e6ed11ddcbee77c" => :mountain_lion
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
    %w(neko nekoc nekoml nekotools).each do |file|
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
