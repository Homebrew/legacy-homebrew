class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3030stable.tar.gz"
  version "3.03.0"
  sha256 "fa4b674794afa1d81ca86c3eeb29dbe2b4675a92011327968c895397f0a35275"

  bottle do
    cellar :any_skip_relocation
    sha256 "87c361784c926b6638456aef411eeb6ae3193b80af796156b2283369d9fb84d5" => :el_capitan
    sha256 "599422acc1aaff93d1cf335fe02f04f1248aa8aba23ab628615e67bf95395552" => :yosemite
    sha256 "8e7f1a4fab4f714779b875dfafea30d3c57978817b64be676ed4de5f6dbedb0c" => :mavericks
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
