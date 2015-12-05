class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data."
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/nifi/0.3.0/nifi-0.3.0-bin.tar.gz"
  sha256 "706a068870a2db85e4fb244a27d302d931c93e358d6001765a5f61b65f1ddfa1"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]

    ENV["NIFI_HOME"] = libexec

    bin.install libexec/"bin/nifi.sh" => "nifi"
    bin.env_script_all_files libexec/"bin/", :NIFI_HOME => libexec
  end

  test do
    system bin/"nifi", "status"
  end
end
