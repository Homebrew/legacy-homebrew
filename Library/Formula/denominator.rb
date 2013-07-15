require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.0.0/denominator?direct',
    :using  => :nounzip
  version '3.0.0'
  sha1 'c5ef7d0782b3b8c11446f3a073626f4e90ef45b3'

  test do
    system "#{bin}/denominator", "help"
  end
end
