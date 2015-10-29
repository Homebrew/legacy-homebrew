class Ngrok < Formula
  homepage "https://ngrok.com"
  desc "Expose localhost to the internet and capture traffic for replay"

  version "2.0.19"
  url "https://dl.ngrok.com/ngrok_#{version}_darwin_amd64.zip"
  sha256 "ec307920b86778db4c632434cb9fff01ead9edd7438618aab87f5e891791f799"

  def install
    bin.install "ngrok"
  end

  test do
    system "#{bin}/ngrok", "version"
  end
end
