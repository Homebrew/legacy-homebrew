require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.2.0/denominator?direct',
    :using  => :nounzip
  version '3.2.0'
  sha1 '927e407907b27436aec038480a212377c87d1987'

  test do
    system "#{bin}/denominator", "help"
  end
end
