require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.6.0/denominator?direct',
    :using  => :nounzip
  version '3.6.0'
  sha1 '8eea233c46c653e963d774158537d7574ed352ea'

  test do
    system "#{bin}/denominator", "help"
  end
end
