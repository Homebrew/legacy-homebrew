class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "http://boot-clj.com"
  url "https://github.com/boot-clj/boot-bin/releases/download/2.5.2/boot.sh",
      :using => :nounzip
  sha256 "895def8ef37f4b78bb37a26566ce970dc24219e880154a18ef7ade5a778d3a2f"

  bottle :unneeded

  depends_on :java

  def install
    bin.install "boot.sh" => "boot"
  end

  test do
    ENV.java_cache

    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
