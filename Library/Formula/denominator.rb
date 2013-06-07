require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.1.4/denominator?direct',
    :using  => :nounzip
  version '1.1.4'
  sha1 '1613e16a5eeeab089f6322343103e5ecf77b8238'

  test do
    system "#{bin}/denominator", "help"
  end
end
