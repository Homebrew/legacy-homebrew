class Myrica < Formula
  homepage "https://github.com/tomokuni/Myrica"
  version "2.004.20150214"
  url "https://github.com/tomokuni/Myrica/raw/#{version}/Myrica.TTC"
  sha1 "45b5354377672d22c9d01c9fdd16f170c8c1d612"

  def install
    prefix.install "Myrica.TTC"
  end

  def caveats
    <<-EOS.undent
      Do following command to use Myrica fonts.

      $ cp /usr/local/Celler/myrica/#{version}/Myrica.TCC ~/Library/Fonts/
      $ fc-cache
    EOS
  end

end
