require 'formula'

class Denominator < ScriptFileFormula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/3.3.0/denominator?direct',
    :using  => :nounzip
  version '3.3.0'
  sha1 '28ecc9b17dcefb2061798441d93cd2aa814292ca'

  test do
    system "#{bin}/denominator", "help"
  end
end
