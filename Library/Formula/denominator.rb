require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/4.3.0/denominator?direct',
    :using  => :nounzip
  version '4.3.0'
  sha1 '44ce57b254792fff953a006b34aef3df359721bc'

  test do
    system "#{bin}/denominator", "help"
  end
end
