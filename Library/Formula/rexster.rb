class Rexster < Formula
  homepage "http://rexster.tinkerpop.com/"
  url "http://tinkerpop.com/downloads/rexster/rexster-server-2.6.0.zip"
  sha1 "756e317dc4db1b1627b250f3442405518bd9fc6b"

  depends_on :java

  def install
    rm_rf Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]

    inreplace "#{libexec}/bin/rexster.sh", "exec $JAVA", "cd #{libexec}\nexec $JAVA"
    (bin/"rexster.sh").write_env_script libexec/"bin/rexster.sh", Language::Java.java_home_env
  end

  test do
    assert_match(/Rexster version \[#{version}\]/, pipe_output("#{bin}/rexster.sh -v"))
  end
end
