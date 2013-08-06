require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.4.0/denominator?direct',
    :using  => :nounzip
  version '3.4.0'
  sha1 '01e81f21f232c4256ec766206e9056e40ca0d7ed'

  test do
    system "#{bin}/denominator", "help"
  end
end
