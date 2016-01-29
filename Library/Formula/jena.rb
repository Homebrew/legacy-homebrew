class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://archive.apache.org/dist/jena/binaries/apache-jena-3.0.1.tar.gz"
  sha256 "8175f1624dbe33ff33054ee2a8e8ef556af19f1d3a1065b8bbfcbf84ad3c3562"

  bottle :unneeded

  def shim_script(target)
    <<-EOS.undent
      #!/usr/bin/env bash
      export JENA_HOME="#{libexec}"
      "$JENA_HOME/bin/#{target}" "$@"
    EOS
  end

  conflicts_with "samba",
    :because => "both install `tdbbackup` and `tdbdump` binaries"

  def install
    rm_rf "bat" # Remove Windows scripts

    prefix.install %w[LICENSE NOTICE README]
    doc.install ["javadoc-arq", "javadoc-core", "javadoc-tdb", "src-examples"]
    libexec.install Dir["*"]
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      (bin+bin_name).write shim_script(bin_name)
    end
  end
end
