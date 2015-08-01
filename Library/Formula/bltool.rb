class Bltool < Formula
  desc "Tool for command-line interaction with backloggery.com"
  homepage "https://github.com/ToxicFrog/bltool"
  url "https://github.com/ToxicFrog/bltool/releases/download/v0.2.1/bltool-0.2.1.zip"
  sha256 "dceb5812058699b726bcd43a87c703eba39527959f712ef262919e0e14d6608e"

  head do
    url "https://github.com/ToxicFrog/bltool.git"
    depends_on "leiningen" => :build
  end

  def install
    if build.head?
      system "lein", "uberjar"
      bltool_jar = Dir["target/bltool-*-standalone.jar"][0]
    else
      bltool_jar = "bltool.jar"
    end

    libexec.install bltool_jar
    bin.write_jar_script libexec/File.basename(bltool_jar), "bltool"
  end

  test do
    input_data = <<-EOS.undent
      [{:id "12527736",
        :name "Assassin's Creed",
        :platform "360",
        :progress "unfinished"}]
    EOS

    output_regex = /12527736\s+360\s+unfinished\s+Assassin's Creed/

    (testpath/"test.edn").write input_data
    system bin/"bltool", "--from", "edn", "--to", "text", "--input", testpath/"test.edn", "--output", testpath/"test.txt"
    assert_match output_regex, (testpath/"test.txt").read
  end
end
