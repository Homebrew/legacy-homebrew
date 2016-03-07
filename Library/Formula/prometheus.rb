class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus.git",
    :tag => "0.17.0",
    :revision => "e11fab35d76d19c5c49b7d85e28275f894d3ada4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5bd980c21a17cc3144c6f926630a043524473c597187a819023fe17bb1151cd" => :el_capitan
    sha256 "de08265b7154e3b4036b2dc3a02902f6fe2ad6ae570e195bd1c3852f8658b4ec" => :yosemite
    sha256 "fc21c6a2a8e36b7154308afa4215616455579fc9b83023627f05920df88d90d0" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]
  end

  test do
    rules = <<-EOS.undent
    # Saving the per-job HTTP in-progress request count as a new set of time series:
      job:http_inprogress_requests:sum = sum(http_inprogress_requests) by (job)
    EOS
    (testpath/"rules.example").write(rules)
    system "#{bin}/promtool", "check-rules", testpath/"rules.example"
  end
end
