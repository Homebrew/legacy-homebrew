class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "http://pmd.sourceforge.net/"
  head "https://github.com/pmd/pmd.git"

  stable do
    url "https://github.com/pmd/pmd/releases/download/pmd_releases/5.4.1/pmd-src-5.4.1.zip"
    sha256 "1dcef1a9f6e7681e474faf2d37ed82b408edf880b3707f17f42b0046cf3130a1"

    # Some versions of PMD have incorrect versions specified for parent POM's.
    # When updating this formula, please grep for the version number and
    # make sure there are no SNAPSHOT versions specified.
    patch do
      url "https://gist.githubusercontent.com/rwhogg/39fb99f1c5c01e113c6d/raw/35c4933ff54fde394dac02cc4212c2a7a2a273a2/pom-versions.diff"
      sha256 "80c023c8384adb9963a6c434a1224b029a4a27b720dbb9ea50fe780c65150fdb"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "200b328de630494f9af715dea361f58a33cbe63f05f92655e24fa303718081ec" => :el_capitan
    sha256 "e77b25de6a13bb512d2962eab1d643d76ac7411f18bf38f049774d193ccfd43c" => :yosemite
    sha256 "e5ed61e35b5c980b0e1bcf616bc2615f1c5310ad66ce8f4901ca225764e7e78c" => :mavericks
  end

  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "clean", "package"

    doc.install "LICENSE", "NOTICE", "README.md"

    # The mvn package target produces a .zip with all the jars needed for PMD
    require "rexml/document"
    pom_xml = REXML::Document.new(File.new("pom.xml"))
    version_string = REXML::XPath.first(pom_xml, "string(/pom:project/pom:version)", "pom" => "http://maven.apache.org/POM/4.0.0")
    safe_system "unzip", buildpath/"pmd-dist/target/pmd-bin-#{version_string}.zip"
    libexec.install "pmd-bin-#{version_string}/bin", "pmd-bin-#{version_string}/lib"

    bin.install_symlink "#{libexec}/bin/run.sh" => "pmd"
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
