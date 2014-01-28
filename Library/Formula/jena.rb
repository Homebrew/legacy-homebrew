require 'formula'

class Jena < Formula
  homepage 'http://jena.apache.org/'
  url 'http://www.apache.org/dist/jena/binaries/apache-jena-2.11.0.tar.gz'
  sha1 '50d1a13092d1027221222b6f3a4c6c495837a392'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      export JENA_HOME="#{libexec}"
      "$JENA_HOME/bin/#{target}" "$@"
    EOS
  end

  def install
    # Remove Windows scripts
    rm_rf Dir['bat']

    # Install files
    prefix.install %w{ LICENSE ReleaseNotes-Jena.txt NOTICE ReleaseNotes-TDB.txt README ReleaseNotes-ARQ.txt }
    doc.install ['javadoc-arq', 'javadoc-core', 'javadoc-sdb', 'javadoc-tdb', 'src-examples']
    libexec.install Dir['*']
    Dir["#{libexec}/bin/*"].map { |p| Pathname.new p }.each { |path|
      bin_name = path.basename
      (bin+bin_name).write shim_script(bin_name)
    }
  end
end
