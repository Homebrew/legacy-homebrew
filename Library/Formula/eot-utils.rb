class EotUtils < Formula
  desc "Tools to convert fonts from OTF/TTF to EOT format"
  homepage "https://www.w3.org/Tools/eot-utils/"
  url "https://www.w3.org/Tools/eot-utils/eot-utilities-1.1.tar.gz"
  sha256 "4eed49dac7052e4147deaddbe025c7dfb404fc847d9fe71e1c42eba5620e6431"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2a4e0f385fa861baf54ac3c483f5599bc96994b3797fe00430653f1a5c28ba4" => :el_capitan
    sha256 "3276e755d84fda54851733b693e56922ddb597f1ac4f14792f4221ce794832da" => :yosemite
    sha256 "d22988bd2c4ba4bb945a80d997fb06532579a09a3bc0c8be86c832f7bbc57a42" => :mavericks
    sha256 "d782ddcacccfa504b99a6733a2c5ae5cba48298f3476ecf506b610465d0fe98d" => :mountain_lion
  end

  resource "eot" do
    url "https://github.com/RoelN/font-face-render-check/raw/98f0adda9cfe44fe97f6d538aa893a37905a7add/dev/pixelambacht-dash.eot"
    sha256 "23d6fbe778abe8fe51cfc5ea22f8e061b4c8d32b096ef4a252ba6f2f00406c91"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("eot").stage do
      system "#{bin}/eotinfo", "pixelambacht-dash.eot"
    end
  end
end
