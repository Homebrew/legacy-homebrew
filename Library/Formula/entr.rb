class Entr < Formula
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.1.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.1.tar.gz"
  sha256 "f0f27e8fc610936f5ec72891687fc77e0df0b21172f14e85ff381d2fe5e3aadd"

  bottle do
    cellar :any
    sha1 "da32289bea210e36f6dffe7ef419d5ea8654afb2" => :yosemite
    sha1 "b6a84ff6bddd4d59b3abf4a706b1a70d19e302f4" => :mavericks
    sha1 "10422a889ccdc6bcb411d505407c43f6412e8443" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -d echo 'New File'", testpath).strip
  end
end
