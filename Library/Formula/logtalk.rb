class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3041stable.tar.gz"
  version "3.04.1"
  sha256 "40881584b52bd016bf4826d2c8bd0746da3a23319943034130b97760ddf039e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "61622a7cd6aa9406cd892d703fc247f0491f5418e44f0818222ca9e7f5cfd111" => :el_capitan
    sha256 "afd0c12db150d8e7845855b8eefeebfa1a1c79d7c12b19288c38092774699fa0" => :yosemite
    sha256 "fe1ca2eb1b969dc3b903e45c34ac14d6fa0b941bf0673ff37a41b6e0f057975d" => :mavericks
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
