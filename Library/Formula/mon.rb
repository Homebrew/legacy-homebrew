class Mon < Formula
  desc "Monitor hosts/services/whatever and alert about problems"
  homepage "https://github.com/visionmedia/mon"
  url "https://github.com/visionmedia/mon/archive/1.2.3.tar.gz"
  sha256 "978711a1d37ede3fc5a05c778a2365ee234b196a44b6c0c69078a6c459e686ac"

  bottle do
    cellar :any
    sha1 "4279caae6fd47b43bb884787daff34a0c65c915b" => :mavericks
    sha1 "07ff0b1e1cf96cd22a57c26e8b03174964fa928f" => :mountain_lion
    sha1 "c0f4c73f81ceb8773a40fbb5c9385f61ce9a25be" => :lion
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"mon", "-V"
  end
end
