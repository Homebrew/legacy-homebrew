class EotUtils < Formula
  homepage "https://www.w3.org/Tools/eot-utils/"
  url "https://www.w3.org/Tools/eot-utils/eot-utilities-1.1.tar.gz"
  sha256 "4eed49dac7052e4147deaddbe025c7dfb404fc847d9fe71e1c42eba5620e6431"

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
