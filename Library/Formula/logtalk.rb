class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3041stable.tar.gz"
  version "3.04.1"
  sha256 "40881584b52bd016bf4826d2c8bd0746da3a23319943034130b97760ddf039e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "31e3c5b6c4f28b5242fcfdd80491a537a8fb31094a64a7382d5e3c8889449a3f" => :el_capitan
    sha256 "99faf02bb790e1c0a8b9822e3aef26e78e2a984140989d0a838e3c267e8f16d2" => :yosemite
    sha256 "5bd8f9d449c01fda26f3085ea1501cdff0477ae21b1c01f367f7ffe5f386b8fa" => :mavericks
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
