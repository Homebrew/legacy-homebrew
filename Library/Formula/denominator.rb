require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/4.3.3/denominator?direct',
    :using  => :nounzip
  sha1 'df078fe7e1c3739ea17dfeced936515026890c1e'

  test do
    system "#{bin}/denominator", "help"
  end
end
