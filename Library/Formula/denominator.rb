require 'formula'

class Denominator < Formula
  # nounzip as this is a single executable file; it is a shell script wrapper around
  # a java jar file
  homepage 'https://github.com/Netflix/denominator/tree/master/denominator-cli'
  url 'http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/1.2.0/denominator?direct',
    :using  => :nounzip
  version '1.2.0'
  sha1 '9331a1eb9c4c68c40b621e0b92d7e1e471a56bae'

  def install
    bin.install "denominator?direct" => "denominator"
  end

  test do
    system "#{bin}/denominator", "help"
  end
end
