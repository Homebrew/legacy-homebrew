class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "http://boot-clj.com"
  url "https://github.com/boot-clj/boot/releases/download/2.4.0/boot.sh",
      :using => :nounzip
  sha256 "42056007935cf76fcb326fbfa59436d0598464b13ff444404db4718afdfe6d01"

  bottle :unneeded

  depends_on :java

  def install
    bin.install "boot.sh" => "boot"
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
