class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.3.6.tar.gz"
  sha256 "80a979aacda950c227542f2ddd0604c28f66fe31223c608b4f717e5f08fb0cbf"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :java => :build
  depends_on :emacs => :build

  bottle do
    cellar :any_skip_relocation
    sha256 "3fc08a72e93eaf45c95d093defbbf57c56e8dd228bd74d86b05ab83948f528a0" => :el_capitan
    sha256 "073708be8b88d4299187e7989c19db18ed637976728e8bceb4bb2201f121d526" => :yosemite
    sha256 "af64d00069e798e3ccdcc84fc1d29bd42afbca0563fd790d9d95fced12fc7ff1" => :mavericks
  end

  def install
    # nesc is unable to build in parallel because multiple emacs instances
    # lead to locking on the same file
    ENV.deparallelize

    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
