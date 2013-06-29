require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/2.0.0/denominator?direct',
    :using  => :nounzip
  version '2.0.0'
  sha1 '759d6168a28007699177dd0f593e19f41aafa545'

  test do
    system "#{bin}/denominator", "help"
  end
end
