require 'formula'

class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage 'http://jena.apache.org/'
  url 'http://archive.apache.org/dist/jena/binaries/apache-jena-2.12.1.tar.gz'
  sha1 '4493a893b12b119d89d991d6d9c1f11f0700139b'

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
