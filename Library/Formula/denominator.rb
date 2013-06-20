require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.3.0/denominator?direct',
    :using  => :nounzip
  version '1.3.0'
  sha1 '0d6a2314684a7748a7b50289149ec4812e4a25d5'

  test do
    system "#{bin}/denominator", "help"
  end
end
