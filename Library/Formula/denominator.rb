require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.2.0/denominator?direct',
    :using  => :nounzip
  version '1.2.0'
  sha1 '9331a1eb9c4c68c40b621e0b92d7e1e471a56bae'

  test do
    system "#{bin}/denominator", "help"
  end
end
