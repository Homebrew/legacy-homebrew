require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.7.0/denominator?direct',
    :using  => :nounzip
  version '3.7.0'
  sha1 'e55e6c724277d5a7b1b38dff81df2ef49c9a4ba1'

  test do
    system "#{bin}/denominator", "help"
  end
end
