require 'formula'

class Denominator < Formula
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  # nounzip as this is a single executable file
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.1.2/denominator?direct', :using  => :nounzip
  sha1 '8fd15d9579c7e1e9b79b3e1987a5dfb61499fb24'
  version '1.1.2'

  def install
    mv "denominator?direct", "denominator"
    bin.install "denominator"
  end

end
