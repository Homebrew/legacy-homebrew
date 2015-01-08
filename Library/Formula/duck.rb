require "formula"

class Duck < Formula
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-16323.tar.gz"
  version "4.6.2.16323"
  head "https://svn.cyberduck.io/trunk/"
  sha1 "4835fde547c4467a2863f31dd775034da6b83be3"

  depends_on :java => ["1.7", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "openssl"

  def install
    system "ant", "-Dbuild.compile.target=1.7", "-Drevision=16323", "cli"
    system "install_name_tool", "-change", "/usr/lib/libcrypto.0.9.8.dylib", "/usr/local/opt/openssl/lib/libcrypto.dylib", "build/duck.bundle/Contents/Frameworks/libPrime.dylib"
    system "install_name_tool", "-change", "/usr/lib/libcrypto.0.9.8.dylib", "/usr/local/opt/openssl/lib/libcrypto.dylib", "build/duck.bundle/Contents/Frameworks/librococoa.dylib"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    unless "Cyberduck 4.6.2 (16323)\n".eql? %x[#{bin}/duck -version]
      raise "Version mismatch"
    end
    filename = (testpath/"test")
    system "#{bin}/duck", "--download", stable.url, filename
    filename.verify_checksum stable.checksum
  end
end
