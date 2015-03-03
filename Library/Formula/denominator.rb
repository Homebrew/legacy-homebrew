class Denominator < Formula
  # This is a shell script wrapping a java jar; download as single file using nounzip
  homepage "https://github.com/Netflix/denominator/tree/master/cli"
  url "http://dl.bintray.com/content/netflixoss/denominator/denominator-cli/release/4.3.3/denominator?direct",
    :using  => :nounzip
  sha1 "df078fe7e1c3739ea17dfeced936515026890c1e"

  def install
    bin.install "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
