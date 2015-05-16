require "formula"

class Gant < Formula
  homepage "http://gant.codehaus.org/"
  url "http://dist.codehaus.org/gant/distributions/gant-1.9.11-_groovy-2.3.0.zip"
  version "1.9.11"
  sha1 "5601db2f5001de16b856330abec7b58e1fbf4779"

  depends_on "groovy"

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    libexec.install %w[bin lib conf]

    ENV["GANT_HOME"] = libexec
    bin.install libexec/"bin/gant"
    bin.env_script_all_files(libexec+"bin", :GANT_HOME => ENV["GANT_HOME"])
  end

  test do
    (testpath/"build.gant").write <<-EOS.undent
      includeTargets << gant.targets.Clean
      cleanPattern << ['**/*~',  '**/*.bak']
      cleanDirectory << 'build'

      target(stuff: 'A target to do some stuff.') {
        println 'Stuff'
        depends clean
        echo message: 'A default message from Ant.'
        otherStuff()
      }

      target(otherStuff: 'A target to do some other stuff') {
        println 'OtherStuff'
        echo message: 'Another message from Ant.'
        clean()
      }

      setDefaultTarget stuff
    EOS
    output = `#{bin}/gant`.strip
    assert_match /BUILD SUCCESSFUL/, output
  end
end
