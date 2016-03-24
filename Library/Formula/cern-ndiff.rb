class CernNdiff < Formula
  desc "Numerical diff tool"
  # Note: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "http://svn.cern.ch/guest/madx/tags/5.02.08/madX/tools/numdiff"
  head "http://svn.cern.ch/guest/madx/trunk/madX/tools/numdiff"

  bottle do
    cellar :any_skip_relocation
    sha256 "84e844f2a1410354013d7d74dca5435d4e080cf4719a4e35adc20e15ce120abf" => :el_capitan
    sha256 "1b91fd3501e612ec105d8dedc39077a9daefc246a0606293d17c4066b0d9d5d6" => :yosemite
    sha256 "328fe91a507312403f921151b4653c2eb26bbfbf81f131912d583d2fc47ff5c1" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/numdiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
