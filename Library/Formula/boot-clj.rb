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

  def post_install
    # Work correctly in sandboxes.
    # (Q.v. <https://github.com/Homebrew/homebrew/pull/44254>)
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{ENV["HOME"]}"

    # Use the wrapper to update Boot's JAR files too.
    # (Q.v. <https://github.com/boot-clj/boot/tree/2.2.0#install>)
    system bin/"boot", "--update"
  end

  test do
    ENV.java_cache

    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
