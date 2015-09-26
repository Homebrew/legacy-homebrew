class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://archive.apache.org/dist/jena/binaries/apache-jena-2.12.1.tar.gz"
  sha256 "5bbda78a873c1f27af1719e1d1e724a56a0739d90a9450fc3b4b710ad128734b"

  def shim_script(target)
    <<-EOS.undent
      #!/usr/bin/env bash
      export JENA_HOME="#{libexec}"
      "$JENA_HOME/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_rf "bat" # Remove Windows scripts

    prefix.install %w[LICENSE ReleaseNotes-Jena.txt NOTICE ReleaseNotes-TDB.txt README ReleaseNotes-ARQ.txt]
    doc.install ["javadoc-arq", "javadoc-core", "javadoc-sdb", "javadoc-tdb", "src-examples"]
    libexec.install Dir["*"]
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      (bin+bin_name).write shim_script(bin_name)
    end
  end
end
