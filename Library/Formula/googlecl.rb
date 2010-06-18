require 'formula'

# Include a private copy of this library
class Gdata <Formula
  url 'http://gdata-python-client.googlecode.com/files/gdata-2.0.10.tar.gz'
  homepage 'http://code.google.com/p/gdata-python-client/'
  sha1 'b3eb311f844c188a1f5f599b5cdc2e732d78c796'
end

class Googlecl <Formula
  url 'http://googlecl.googlecode.com/files/googlecl-0.9.5.tar.gz'
  homepage 'http://code.google.com/p/googlecl/'
  sha1 '4aec2e8401ef27791036744d41cf7c277ce9afd3'

  def install
    libexec.install Dir["src/*"]
    Gdata.new.brew { libexec.install Dir["src/*"] }
    man1.install 'man/google.1'
    
    bin.mkpath
    ln_s libexec+'google', bin
  end
end
