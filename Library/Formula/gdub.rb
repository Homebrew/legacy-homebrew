class Gdub < Formula
  desc "Gdub is a Gradle wrapper wrapper"
  homepage "http://www.gdub.rocks"
  url "https://github.com/dougborg/gdub/archive/v0.1.0.tar.gz"
  sha256 "ddf2572cc67b8df3293b1707720c6ef09d6caf73227fa869a73b16239df959c3"

  bottle :unneeded

  depends_on "gradle"

  def install
    bin.install "bin/gw"
  end

  test do
    ENV.java_cache

    system "gradle", "init"
    cd "gradle" do
      system bin/"gw", "tasks"
    end
  end
end
