class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "http://boot-clj.com"
  url "https://github.com/boot-clj/boot/releases/download/2.2.0/boot.sh",
      :using => :nounzip
  sha256 "2e7d9c501ba3e59ae9f23ce21a8a9f8d24177a346238ee3710f7dd0adbddea33"

  bottle :unneeded

  depends_on :java

  def install
    bin.install "boot.sh" => "boot"
  end

  def caveats; <<-EOS.undent
    Note that only the Boot wrapper was updated! To get the updated
    Boot *library* (i.e., “the real Boot”), you must run:

        boot -u

    For more information, see <https://github.com/boot-clj/boot/blob/master/README.md#install>.
    EOS
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
