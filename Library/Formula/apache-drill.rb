class ApacheDrill < Formula
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-0.9.0/apache-drill-0.9.0.tar.gz"
  sha256 "1680b4b937d26623f0f01d7719b0809decf3341f445f5caea3feed1ecbc16c4d"

  def install
    libexec.install Dir["*"]
    ["drill_dumpcat", "runbit", "sqlline"].each do |bin_file|
      bin.write_exec_script Dir["#{libexec}/bin/#{bin_file}"]
    end
  end

  test do
    system "#{bin}/sqlline <<< 'SELECT * FROM cp.`employee.json`;'"
  end
end
