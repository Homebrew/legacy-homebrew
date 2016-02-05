class Sbuild < Formula
  desc "Scala-based build system"
  homepage "http://sbuild.org"
  url "http://sbuild.org/uploads/sbuild/0.7.7/sbuild-0.7.7-dist.zip"
  sha256 "606bc09603707f31d9ca5bc306ba01b171f8400e643261acd28da7a1a24dfb23"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install Dir["*"]
    chmod 0755, libexec/"bin/sbuild"
    bin.install_symlink libexec/"bin/sbuild"
  end

  test do
    expected = <<-EOS.undent
      import de.tototec.sbuild._

      @version("#{version}")
      class SBuild(implicit _project: Project) {

        Target("phony:clean") exec {
          Path("target").deleteRecursive
        }

        Target("phony:hello") help "Greet me" exec {
          println("Hello you")
        }

      }
    EOS
    system bin/"sbuild", "--create-stub"
    assert_equal expected, (testpath/"Sbuild.scala").read
  end
end
