class Taylor < Formula
    desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
    homepage "https://github.com/yopeso/Taylor/"
    url "https://github.com/yopeso/Taylor/archive/0.1.1.tar.gz"
    sha256 "b809d0b94c1ae2dc1730ae46ef9438e099b9fd52ce53e6dc7857eb34d68b612c"
    head "https://github.com/yopeso/Taylor.git"

    depends_on :xcode => ["7.2", :build]

    def install
        system "make", "install_homebrew", "PREFIX=#{prefix}"
    end

    test do
    system "(#{bin}/taylor --help; true)"
  end
end
