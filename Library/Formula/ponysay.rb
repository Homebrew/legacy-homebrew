class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.2.tar.gz"
  sha256 "69e98a7966353de2f232cbdaccd8ef7dbc5d0bcede9bf7280a676793e8625b0d"

  bottle do
    revision 1
    sha1 "77682c4c9a1114e8c71d27ef21483ea709ec8614" => :yosemite
    sha1 "90083a6bd5118323ae7ea7b3117c43c6b10bdd72" => :mavericks
    sha1 "085a01cbf4ee1ed72361e87a040578e72369799e" => :mountain_lion
  end

  depends_on :python3
  depends_on "coreutils"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
