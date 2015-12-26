class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3022stable.tar.gz"
  version "3.02.2"
  sha256 "45fbb107156ae3baf088c84475cc1ea0a8e519cc09ae929e2480d0c62047e5e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "c285cc62bafef8baa984f2573dc43b9029d5b7dd55c283a1c5a8e4d40be3285b" => :el_capitan
    sha256 "60300d82ebd691a07e10536a7d839219ab1c9172ff10f997aef3a50da7274576" => :yosemite
    sha256 "a04c155a67a2875b82b4246feec8f7ce6f5716302d171f23d2c0d8501cedbe11" => :mavericks
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with? "swi-prolog"
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
