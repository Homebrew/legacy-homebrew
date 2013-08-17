require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.5.0/denominator?direct',
    :using  => :nounzip
  version '3.5.0'
  sha1 '87048817cf1b4ddcade05b8763ce3b6088493eb7'

  test do
    system "#{bin}/denominator", "help"
  end
end
