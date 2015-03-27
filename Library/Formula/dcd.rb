class Dcd < Formula
  homepage "https://github.com/Hackerpilot/DCD"
  url "https://github.com/Hackerpilot/DCD.git", :tag => "v0.5.1",
    :revision => "351bf2ee2d5f1c4986c2c5957f542dda17b1d085"

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end
end
