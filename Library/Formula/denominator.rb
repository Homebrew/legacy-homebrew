require 'formula'

class Denominator < Formula
  # nounzip as this is a single executable file; it is a shell script wrapper around
  # a java jar file
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.1.3/denominator?direct',
    :using  => :nounzip
  version '1.1.3'
  sha1 '97da0f22a2eb2854339677f5576b8995d81b2ad5'

  def install
    bin.install "denominator?direct" => "denominator"
  end

  test do
    system "#{bin}/denominator", "help"
  end
end
