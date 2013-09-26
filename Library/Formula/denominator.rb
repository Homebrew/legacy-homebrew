require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/4.3.2/denominator?direct',
    :using  => :nounzip
  version '4.3.2'
  sha1 '9cdc9d1f3121512eb3bdb0ee93540cce30926702'

  test do
    system "#{bin}/denominator", "help"
  end
end
