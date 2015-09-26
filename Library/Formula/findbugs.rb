class Findbugs < Formula
  desc "Find bugs in Java programs through static analysis"
  homepage "http://findbugs.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/findbugs/findbugs/3.0.1/findbugs-3.0.1.tar.gz"
  sha256 "e80e0da0c213a27504ef3188ef25f107651700ffc66433eac6a7454bbe336419"

  conflicts_with "fb-client",
    :because => "findbugs and fb-client both install a `fb` binary"

  depends_on :java => "1.7+"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]

    bin.write_exec_script libexec/"bin/fb"
    bin.write_exec_script libexec/"bin/findbugs"
  end

  def caveats; <<-EOS.undent
    Some tools might refer findbugs by env variable.
    After installation, set $FINDBUGS_HOME in your profile:
      export FINDBUGS_HOME=#{libexec}
    EOS
  end

  test do
    system "#{bin}/fb"
  end
end
