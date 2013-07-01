require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/2.1.0/denominator?direct',
    :using  => :nounzip
  version '2.1.0'
  sha1 '7a4ec95250e83c29c1d789c1fb23c4da649df35e'

  test do
    system "#{bin}/denominator", "help"
  end
end
