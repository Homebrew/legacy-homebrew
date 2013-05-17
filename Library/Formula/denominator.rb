require 'formula'

class Denominator < Formula
  # nounzip as this is a single executable file; it is a shell script wrapper around
  # a java jar file
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.1.2/denominator?direct',
    :using  => :nounzip
  version '1.1.2'
  sha1 '8fd15d9579c7e1e9b79b3e1987a5dfb61499fb24'

  def install
    bin.install "denominator?direct" => "denominator"
  end

  test do
    system "#{bin}/denominator", "help"
  end
end
