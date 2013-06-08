require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.2.1/denominator?direct',
    :using  => :nounzip
  version '1.2.1'
  sha1 '2d9b9248bdff1f5c09a19bf6d71f7f28ef3e1306'

  test do
    system "#{bin}/denominator", "help"
  end
end
