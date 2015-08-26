class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3004stable.tar.gz"
  sha256 "2f1275d43ec5c4c65161b4673ed214311272a8af131a748c37e2ffec33532dfc"
  version "3.00.4"

  bottle do
    cellar :any
    sha256 "ecba33b85ad7147dc41883f467b563814e72fc1e70b062e3805c58ec4712f3a3" => :yosemite
    sha256 "3e78e9174d6dac8e281b922a02264127165cfd0bb90c8b1e092a2c1d5eb68670" => :mavericks
    sha256 "197132d44948afbc3c0ae1c811ff8c2b81a93934f099be8a4271eb49d82ceabf" => :mountain_lion
  end

  option "swi-prolog", "Build using SWI Prolog as backend"
  option "gnu-prolog", "Build using GNU Prolog as backend (Default)"

  if build.include?("swi-prolog")
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
