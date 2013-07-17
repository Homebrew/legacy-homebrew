require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.1.0/denominator?direct',
    :using  => :nounzip
  version '3.1.0'
  sha1 'fc84419686314fe665f16840945887f3f79b142d'

  test do
    system "#{bin}/denominator", "help"
  end
end
