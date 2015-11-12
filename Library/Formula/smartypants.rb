class Smartypants < Formula
  desc "Typography prettifier"
  homepage "https://daringfireball.net/projects/smartypants/"
  url "https://daringfireball.net/projects/downloads/SmartyPants_1.5.1.zip"
  sha256 "2813a12d8dd23f091399195edd7965e130103e439e2a14f298b75b253616d531"

  bottle :unneeded

  def install
    bin.install "SmartyPants.pl" => "smartypants"
  end

  test do
    assert_equal "&#8220;Give me a beer&#8221;, said Mike O&#8217;Connor",
      pipe_output("#{bin}/smartypants",
                  %("Give me a beer", said Mike O'Connor), 0)
  end
end
