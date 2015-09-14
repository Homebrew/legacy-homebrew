class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.2.tar.gz"
  sha256 "69e98a7966353de2f232cbdaccd8ef7dbc5d0bcede9bf7280a676793e8625b0d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "54ccb7373321f78ec9326cda0173abb43a42af9436d0a256e712a5dad6321ad2" => :yosemite
    sha256 "4d873b271541b44186b6aba17fbb7f21f640f9eb388eadba841005b5eab0d61f" => :mavericks
    sha256 "2aad66036605d34d2d55a264fc1afe5a616dc409208ce4e55c31aa83e85da282" => :mountain_lion
  end

  depends_on :python3
  depends_on "coreutils"

  # fix shell completion install paths
  # https://github.com/erkin/ponysay/pull/225
  patch do
    url "https://github.com/tdsmith/ponysay/commit/44fb0f85821eb34a811abb27d2c601a5d30af1f1.diff"
    sha256 "0570b94a1179c189291cd9bad28cb93762aeed5ad6bbc3536027e178d0e6b9df"
  end

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
