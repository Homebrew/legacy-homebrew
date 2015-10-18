class Spark < Formula
  desc "Sparklines for the shell"
  homepage "http://zachholman.com/spark/"
  url "https://github.com/holman/spark/archive/v1.0.1.tar.gz"
  sha256 "a81c1bc538ce8e011f62264fe6f33d28042ff431b510a6359040dc77403ebab6"

  def install
    bin.install "spark"
  end

  test do
    system "#{bin}/spark"
  end
end
