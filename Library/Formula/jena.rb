require 'formula'

class Jena < Formula
  homepage 'http://jena.apache.org/'
  url 'http://www.apache.org/dist/jena/binaries/apache-jena-2.12.0.tar.gz'
  sha1 '12eeed737290e2f0bc0a3180d50a1eda7502ab04'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      export JENA_HOME="#{libexec}"
      "$JENA_HOME/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_rf "bat" # Remove Windows scripts

    prefix.install %w{ LICENSE ReleaseNotes-Jena.txt NOTICE ReleaseNotes-TDB.txt README ReleaseNotes-ARQ.txt }
    doc.install ['javadoc-arq', 'javadoc-core', 'javadoc-sdb', 'javadoc-tdb', 'src-examples']
    libexec.install Dir['*']
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      (bin+bin_name).write shim_script(bin_name)
    end
  end
end
