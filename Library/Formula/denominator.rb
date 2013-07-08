require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/2.2.0/denominator?direct',
    :using  => :nounzip
  version '2.2.0'
  sha1 '981434971b44283a7e7d9b54ffea4e5ef68e9bfa'

  test do
    system "#{bin}/denominator", "help"
  end
end
