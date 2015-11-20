class Nuget < Formula
  desc "NuGet is the package manager for the Microsoft development platform including .NET"
  homepage "https://www.nuget.org"
  url "https://s3.amazonaws.com/homebrew-nuget/nuget-3.2.0.10516.tar.gz"
  version "3.2.0.10516"
  sha256 "1a76e705a3253d020c5ee8a92816f9c10b8604226eab7fcd196ae29e8bfacbda"

  depends_on "mono"

  def install
    bin.install Dir["*"]
  end

  test do
    system "#{bin}/nuget"
  end
end
