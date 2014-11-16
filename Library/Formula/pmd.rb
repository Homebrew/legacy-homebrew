require "formula"

class Pmd < Formula
  homepage "http://pmd.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pmd/pmd/5.1.3/pmd-src-5.1.3.zip"
  sha1 "da6023d73e078444a7b76e8a7a0cfbeb421221e4"

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]

    doc.install "LICENSE", "NOTICE", "ReadMe.txt", "licences", Dir["docs/*"]
    libexec.install "bin", "etc", "lib"

    bin.install_symlink "#{libexec}/bin/run.sh" => "pmd"

    # the run script references paths which don't account for the
    # file structure of this brew.
    inreplace "#{libexec}/bin/run.sh", "${script_dir}/../lib", "#{libexec}/lib"
  end

  def caveats; <<-EOS.undent
    Run with `pmd` (instead of `run.sh` as described in the documentation).
    EOS
  end

  test do
    (testpath/"java/testClass.java").write <<-EOS.undent
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    EOS

    system "#{bin}/pmd", "pmd", "-d", "#{testpath}/java", "-R",
      "rulesets/java/basic.xml", "-f", "textcolor", "-l", "java"
  end
end
