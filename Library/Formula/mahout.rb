class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage "https://mahout.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=mahout/0.11.1/apache-mahout-distribution-0.11.1.tar.gz"
  sha256 "0731e01ba9610f034cbd5316b9ba911356bedca9ba7915db4e958180afaf9cc9"

  head do
    url "https://github.com/apache/mahout.git"
    depends_on "maven" => :build
  end

  bottle :unneeded

  depends_on "hadoop"
  depends_on :java

  def install
    if build.head?
      ENV.java_cache

      chmod 755, "./bin"
      system "mvn", "-DskipTests", "clean", "install"
    end

    libexec.install "bin"

    if build.head?
      libexec.install Dir["buildtools/target/*.jar"]
      libexec.install Dir["core/target/*.jar"]
      libexec.install Dir["examples/target/*.jar"]
      libexec.install Dir["math/target/*.jar"]
    else
      libexec.install Dir["*.jar"]
    end

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      "x","y"
      0.1234567,0.101201201
    EOS

    assert_match "0.101201201", pipe_output("#{bin}/mahout cat #{testpath}/test.csv")
  end
end
