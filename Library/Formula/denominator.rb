require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/4.1.0/denominator?direct',
    :using  => :nounzip
  version '4.1.0'
  sha1 '3c25e0ecdc9021dc01908871deb90cc46883d7c0'

  test do
    system "#{bin}/denominator", "help"
  end
end
