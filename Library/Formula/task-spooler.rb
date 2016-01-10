class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "http://vicerveza.homeunix.net/~viric/soft/ts/"
  url "http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.5.tar.gz"
  sha256 "216d09dcfbae2f9bfea7582a71494172fe91c33d65499ea01b3bcac0600de96d"

  bottle do
    cellar :any
    sha256 "bda2858d1071b3091c48b9774786c3b88b0ded7cb7a569054aa1774b141e5555" => :yosemite
    sha256 "48fec6fbf078cffbc77ad1a5f7eaa01ca28561efbd5d847957bdf574bbb6c8fe" => :mavericks
    sha256 "00fdb36feaadc5c6f552318cf7e3aed402b1c49ffde203652a0eb0ccf4ffec8b" => :mountain_lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'ts' executable."

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
