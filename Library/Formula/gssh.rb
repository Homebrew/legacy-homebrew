class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/releases/download/v1.1.5/gssh.jar"
  version "1.1.5"
  sha256 "c4f2bf2ea71f4aaae12afa7edf484746ffb63c32e8a582f54f1a0a061b33f28c"

  head "https://github.com/int128/groovy-ssh.git"

  depends_on :java => "1.6+"

  def install
    if build.head?
      system "./gradlew", "shadowJar"
      libexec.install "build/libs/gssh.jar"
    else
      libexec.install "gssh.jar"
    end
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system "gssh"
  end
end
