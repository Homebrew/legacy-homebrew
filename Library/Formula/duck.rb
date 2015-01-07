class Duck < Formula
  homepage "https://duck.sh/"
  url "https://update.cyberduck.io/src/cyberduck-src-16295.tar.gz"
  version "4.6.2.16295"
  head "https://svn.cyberduck.io/trunk/"
  sha1 "45a6549c1af367b65cbdf38dd6a45499f64f117f"

  depends_on :java => ["1.7", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "openssl" => :recommended

  def install
    system "ant", "-Dbuild.compile.target=1.7", "-Drevision=16276", "cli"
    system "install_name_tool", "-change", "/usr/lib/libcrypto.0.9.8.dylib", "/usr/local/opt/openssl/lib/libcrypto.dylib", "build/duck.bundle/Contents/Frameworks/libPrime.dylib"
    system "install_name_tool", "-change", "/usr/lib/libcrypto.0.9.8.dylib", "/usr/local/opt/openssl/lib/libcrypto.dylib", "build/duck.bundle/Contents/Frameworks/librococoa.dylib"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "-version"
  end
end
