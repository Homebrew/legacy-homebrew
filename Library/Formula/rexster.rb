class Rexster < Formula
  desc "Graph server exposing Blueprints graph via REST"
  homepage "http://rexster.tinkerpop.com/"
  url "http://tinkerpop.com/downloads/rexster/rexster-server-2.6.0.zip"
  sha256 "e0cfeb9d8dc6be6f472a17eee06618cb1a41f6a981c15c465786a23bbdb2b149"

  bottle :unneeded

  depends_on :java

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/bin/rexster.sh", "exec $JAVA", "cd #{libexec}\nexec $JAVA"
    (bin/"rexster.sh").write_env_script libexec/"bin/rexster.sh", Language::Java.java_home_env
  end

  test do
    assert_match(/Rexster version \[#{version}\]/, pipe_output("#{bin}/rexster.sh -v"))
  end
end
