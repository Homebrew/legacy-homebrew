class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3020stable.tar.gz"
  version "3.02.0"
  sha256 "4d0c5ad34653eeb71b3c90c084b734cb77e0676f07aa21a5849d6d2ba41763fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "762a151f4c0920768450048f64cddbd65008051466f45ccbc654c4507cc2bd45" => :el_capitan
    sha256 "b51a35524dd1f11e8f4732cc76dec20681c088dddcc4674b61e6946440a69c4d" => :yosemite
    sha256 "586e8e7c5648fcacd5e6f2ac0d83c0cf11dfdfd9eb4484035ca2f47ebba9803c" => :mavericks
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
